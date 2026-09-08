# InputStream Player

Repositorio público de InputStream Player. Aquí se publican la información de
la aplicación, ejemplos de listas compatibles y las releases verificables.

> InputStream Player está pensado para reproducir contenidos para los que el
> usuario tiene autorización de acceso. No incluye listas, credenciales ni
> claves de terceros.

## Compatibilidad

- Versiones disponibles para **iOS**, **tvOS** y **macOS**.
- **HLS** (`.m3u8`), incluido **SAMPLE-AES** cuando la fuente proporciona una
  clave ClearKey/raw-key autorizada.
- **DASH / MPD** (`.mpd`) con CENC y ClearKey/raw-key autorizada.
- **Microsoft Smooth Streaming** (`.ism` / `.isml` y `Manifest`) con
  ClearKey/raw-key autorizada.
- Fuentes en formato **M3U/M3U8** y **JSON**.

No se admiten licencias FairPlay, Widevine o PlayReady que requieran un servidor
de licencias. Una clave solo debe añadirse a una lista cuando el titular del
contenido haya autorizado expresamente su uso.

## Ejemplos de listas

- [M3U/M3U8](samples/inputstreamplayer.m3u): HLS, DASH/MPD y Smooth Streaming,
  con y sin ClearKey.
- [JSON](samples/inputstreamplayer.json): formato plano compatible.
- [Referencia completa de formatos](docs/formatos-de-listas.md).

El fichero combina ejemplos estructurales con una sección de demostraciones
públicas de terceros. La disponibilidad de estas últimas depende de sus
proveedores; las claves de los ejemplos estructurales son valores de reserva.

## Releases

Las versiones publicadas aparecerán en la pestaña
[Releases](https://github.com/jopsis/InputStreamPlayer/releases). Cada IPA se
acompañará de su checksum SHA-256 y notas de versión.

Consulta [cómo verificar e instalar una release](docs/releases.md) antes de
instalarla. La distribución mediante SideStore requiere una cuenta de Apple
válida y está sujeta a los límites de firma de Apple.

## Instalación en iPhone y iPad

InputStream Player se instala mediante **SideStore**, preferiblemente dentro de
**LiveContainer**. Descarga la IPA desde una release oficial y sigue primero las
guías oficiales de instalación:

- [Instalar SideStore](https://docs.sidestore.io/docs/installation/install)
- [Instalar LiveContainer con SideStore](https://livecontainer.github.io/docs/installation)

Una vez configurado LiveContainer, importa la IPA de InputStream Player desde
la release oficial. LiveContainer permite ejecutarla dentro de su contenedor.

## Alcance de este repositorio

Este repositorio no publica código fuente, claves, perfiles de firma,
credenciales ni material de terceros. Las incidencias públicas deben incluir
solo datos que puedan compartirse de forma segura.
