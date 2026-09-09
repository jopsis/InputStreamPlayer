# AGENTS.md

Instrucciones para cualquier agente (o persona) que gestione una release en
este repositorio. Este repo es **solo distribución pública**: información de
la app, ejemplos de listas y releases verificables. El código fuente vive en
un repositorio privado aparte; aquí no se publican fuentes, claves, perfiles
de firma ni credenciales.

## Checklist al publicar una release nueva

Desde 2026-09-09 este paso está automatizado por
`Tooling/distribution/publish-release.sh` en el repositorio de código (privado).
No lo dupliques a mano salvo que ese script falle y necesites recuperar el
proceso manual descrito más abajo.

1. En el repositorio de código: construir el IPA sin firmar de iOS y tvOS
   (misma versión/build en ambos) con `Tooling/distribution/build-ios-ipa.sh`
   / `build-tvos-ipa.sh`.
2. En el repositorio de código: `Tooling/distribution/publish-release.sh
   --check` y, si todo va bien, `Tooling/distribution/publish-release.sh` sin
   flags. Ese script (ejecutándose desde el checkout del código, con este
   repositorio como `PUBLIC_REPO_DIR` — por defecto la ruta hermana
   `../InputStreamPlayer`):
   - crea la release `vX.Y.Z` en GitHub con los 4 artefactos (IPA + `.sha256`
     de iOS y tvOS) y las notas tomadas del `CHANGELOG.md` del código;
   - ejecuta aquí mismo `sidestore/update-source.sh`, y si `apps.json` cambió,
     hace commit y `push` en este repositorio y fuerza un rebuild de Pages.
   - Exige que **este** repositorio esté en `main`, limpio y sincronizado con
     `origin/main` antes de tocar nada — si tienes cambios locales aquí,
     confírmalos o descártalos antes de ejecutarlo.
3. Comprobar que GitHub Pages sirve el JSON actualizado:
   `https://jopsis.github.io/InputStreamPlayer/sidestore/apps.json` (puede
   tardar uno o dos minutos en desplegarse tras el push).
4. Si cambia el `IPHONEOS_DEPLOYMENT_TARGET` del proyecto Xcode, actualizar la
   variable `min_os_version` en `sidestore/update-source.sh` a la vez.

### Recuperación manual (si `publish-release.sh` no está disponible)

```sh
sidestore/update-source.sh
git add sidestore/apps.json
git commit -m "sidestore: actualiza apps.json para vX.Y.Z"
git push
```

`sidestore/update-source.sh` lee las releases ya publicadas con `gh` (requiere
estar autenticado) y regenera `sidestore/apps.json` con la versión, tamaño,
sha256 y fecha reales de cada release que tenga un IPA de iOS sin firmar
adjunto — pero **no crea la release por sí solo**: si el IPA/`.sha256` no
están subidos a mano en GitHub → Releases primero, no hay nada que leer.
**Sin ejecutar este script tras publicar una release, SideStore no verá la
versión nueva** aunque ya esté en GitHub — el source es un fichero estático,
no consulta la API de GitHub en directo.

## Dónde vive cada cosa

| Ruta | Contenido |
|---|---|
| `sidestore/apps.json` | Source AltStore/SideStore, generado — no editar a mano |
| `sidestore/update-source.sh` | Script que regenera `apps.json` desde `gh release list` |
| `sidestore/index.html` | Página con el botón "Add to SideStore" (servida por GitHub Pages) |
| `docs/releases.md`, `docs/releases_en.md` | Instrucciones de verificación/instalación para humanos |
| `README.md`, `README_en.md` | Punto de entrada público, enlaza el source de SideStore |

## Formato del source

Sigue el esquema oficial de AltStore (`name`, `identifier`, `apps[]` con
`versions[]`; ver <https://faq.altstore.io/altstore-pal/sources> y
<https://docs.sidestore.io/docs/advanced/app-sources>). Solo se lista la app
**iOS** (`bundleIdentifier: com.InputStreamPlayer`): tvOS no se instala vía
SideStore, así que su IPA no entra en `apps.json` aunque sí se publique en la
release de GitHub.

## Qué no hacer

- No editar `sidestore/apps.json` a mano: se pierde en la siguiente ejecución
  del script y puede desincronizarse de las releases reales.
- No añadir una versión al source que no tenga ya su release publicada (con
  IPA + `.sha256`) en GitHub: el script solo puede leer lo que existe.
- No prometer compatibilidad FairPlay/Widevine/PlayReady ni instalación fuera
  de SideStore/LiveContainer en la documentación pública: no es el alcance de
  este proyecto (ver el repositorio de código para el detalle DRM).
