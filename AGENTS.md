# AGENTS.md

Instrucciones para cualquier agente (o persona) que gestione una release en
este repositorio. Este repo es **solo distribución pública**: información de
la app, ejemplos de listas y releases verificables. El código fuente vive en
un repositorio privado aparte; aquí no se publican fuentes, claves, perfiles
de firma ni credenciales.

## Checklist al publicar una release nueva

1. Construir el IPA sin firmar (iOS y, si aplica, tvOS) desde el repositorio
   de código con `Tooling/distribution/build-ios-ipa.sh` /
   `build-tvos-ipa.sh`, alineado con la versión y build number del proyecto
   Xcode.
2. Subir manualmente en GitHub → **Releases** → *Draft a new release*:
   - tag `vX.Y.Z` (coincide con `MARKETING_VERSION`);
   - el/los IPA sin firmar, con nombre
     `InputStreamPlayer-iOS-X.Y.Z-BUILD-unsigned.ipa` (y su equivalente tvOS);
   - el fichero `.sha256` de cada IPA;
   - notas de versión en la descripción de la release.
3. **Actualizar el source de SideStore** (no se hace solo):
   ```sh
   sidestore/update-source.sh
   git add sidestore/apps.json
   git commit -m "sidestore: actualiza apps.json para vX.Y.Z"
   git push
   ```
   El script lee las releases publicadas con `gh` (requiere estar
   autenticado) y regenera `sidestore/apps.json` con la versión, tamaño,
   sha256 y fecha reales de cada release que tenga un IPA de iOS sin firmar
   adjunto. **Sin este paso, SideStore no verá la versión nueva** aunque la
   release ya esté publicada en GitHub — el source es un fichero estático,
   no consulta la API de GitHub en directo.
4. Comprobar que GitHub Pages sirve el JSON actualizado:
   `https://jopsis.github.io/InputStreamPlayer/sidestore/apps.json` (puede
   tardar uno o dos minutos en desplegarse tras el push).
5. Si cambia el `IPHONEOS_DEPLOYMENT_TARGET` del proyecto Xcode, actualizar la
   variable `min_os_version` en `sidestore/update-source.sh` a la vez.

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
