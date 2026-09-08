# Releases

Las builds públicas se publican exclusivamente desde la sección
[Releases](https://github.com/jopsis/InputStreamPlayer/releases) de este
repositorio.

Cada entrega incluirá:

- el IPA;
- un fichero `.sha256` con la suma SHA-256 del IPA;
- la versión, fecha y notas de cambio;
- cualquier requisito de compatibilidad conocido.

## Verificación

Antes de instalar, descarga el IPA y su fichero `.sha256` desde la misma
release y comprueba que coinciden. En macOS:

```sh
shasum -a 256 InputStreamPlayer-*.ipa
```

El resultado debe ser idéntico al checksum publicado. No instales archivos
recibidos por canales distintos de esta release o cuyo checksum no coincida.

## Instalación

InputStream Player se instala a través de **SideStore** y se ejecuta dentro de
**LiveContainer**. Antes de descargar una release, configura ambas herramientas
siguiendo su documentación oficial:

- [Guía de instalación de SideStore](https://docs.sidestore.io/docs/installation/install)
- [Guía de instalación de LiveContainer con SideStore](https://livecontainer.github.io/docs/installation)

Después, descarga la IPA y su checksum desde esta release, verifica el archivo
e impórtalo en LiveContainer. Consulta la guía oficial de LiveContainer para
sus requisitos, compatibilidad y pasos de importación.
