# InputStream Player

Reproductor de **tus propias listas** de TV en directo, películas y series, para
iPhone, iPad, Apple TV, Mac y Android/Google TV. En las tiendas y cajones de
apps aparece como **ISPlayer**.

**[isplayer.joplabs.app/es](https://isplayer.joplabs.app/es/)** · [English](README.md)

> No incluye listas, credenciales ni claves de terceros. Está pensado para
> contenido al que tienes derecho a acceder.

Este repositorio es solo de distribución: **releases verificables**,
documentación, ejemplos de listas e incidencias.

## Descargas

| Plataforma | Cómo instalarla |
|---|---|
| **iPhone y iPad** | Con [SideStore](#sidestore): añade el source y recibirás cada versión. |
| **Apple TV** | IPA sin firmar en la [última versión](https://github.com/jopsis/InputStreamPlayer/releases/latest); fírmala con tu cuenta de Apple. |
| **Mac** (Apple Silicon) | ZIP en la [última versión](https://github.com/jopsis/InputStreamPlayer/releases/latest). No está notarizada: [cómo abrirla](docs/releases_es.md#mac-con-apple-silicon). |
| **Android y Google TV** | APK en la [última versión](https://github.com/jopsis/InputStreamPlayer/releases/latest); después se actualiza sola. Si dudas, el *universal*. |

Cada archivo lleva su SHA-256. Pasos detallados y verificación:
[guía de instalación](docs/releases_es.md). Todas las versiones en
[Releases](https://github.com/jopsis/InputStreamPlayer/releases).

### SideStore

[![Añadir a SideStore](https://img.shields.io/badge/SideStore-A%C3%B1adir%20source-14B85C)](sidestore://source?url=https%3A%2F%2Fjopsis.github.io%2FInputStreamPlayer%2Fsidestore%2Fapps.json)

Desde el iPhone, pulsa el botón; o en SideStore → Sources → **+**:
`https://jopsis.github.io/InputStreamPlayer/sidestore/apps.json`.
Instala antes [SideStore](https://docs.sidestore.io/docs/installation/install)
(mejor con [LiveContainer](https://livecontainer.github.io/docs/installation)).

> **Con LiveContainer, activa «Corregir selector de archivos»** en los ajustes
> de la app, o importar una lista desde fichero no hará nada.
> [Más detalle](docs/releases_es.md#ajuste-obligatorio-en-livecontainer-el-selector-de-archivos).

## Qué hace

- **TV en directo** con guía (XMLTV), zapping con el mando y catch-up.
- **Colecciones:** las películas y series de tus listas en su propia pestaña (solo aparece si alguna lista las trae), con filtro por películas o series y por grupo, «Continuar», marcas de visto, favoritos y recientes.
- **Add-ons de Stremio** y listas de **Trakt**; OpenSubtitles de serie. ¿Tienes un servidor Plex? El add-on de Stremio [Plexio](https://plexio.stream/) funciona con él.
- **Imagen en imagen (PiP)** en iPhone, iPad, Mac y teléfonos y tabletas Android: sigue viendo en una ventana flotante mientras usas otras apps. En el iPhone el sonido sigue en segundo plano.
- **Favoritos, recientes y Multiview** (hasta cuatro canales a la vez). Los favoritos —canales, películas y series— se sincronizan entre tus aparatos.
- **Un canal, una tarjeta aunque venga de varias listas** (opcional, apagado por defecto): el mismo canal de varias listas sale una sola vez y al reproducirlo eliges la fuente, con su formato.
- **Tus categorías, a tu orden:** ordena los grupos de tus listas; se recuerda en cada aparato.
- **Sincronización opcional** con tu propio Google Drive y con Trakt.
- **Listas cifradas** `.ispl`: cífralas en el
  [cifrador web](https://isplayer.joplabs.app/es/cifrar/) y comparte solo la
  dirección y una clave.
- **Android:** motores ExoPlayer y mpv, a elegir.
- **Interfaz en español e inglés:** sigue el idioma del sistema (inglés si el
  tuyo no está) y se cambia en Preferencias.

Más información y capturas en la [web](https://isplayer.joplabs.app/es/).

## Formatos

HLS (incluido SAMPLE-AES), DASH/MPD con CENC y Smooth Streaming, con ClearKey
autorizada (escrita en la lista o de un servidor de licencias ClearKey); MP4,
MKV y TS directos. Listas **M3U/M3U8**, **JSON**, listas de canales de OTT
Navigator (OTC) y catálogos VOD, por dirección o fichero, y `.ispl` cifradas.
Widevine con servidor de licencias solo se reproduce en Android (ExoPlayer); no
se admiten FairPlay ni PlayReady.

- [Referencia de formatos de lista](docs/formatos-de-listas_es.md)
- Ejemplos: [M3U](samples/inputstreamplayer.m3u) ·
  [JSON](samples/inputstreamplayer.json) ·
  [catálogo VOD](samples/catalogo-vod.json)

## Mac

Dos interfaces (Centro multimedia y Clásica), decodificación por hardware,
teclado y ratón. [Atajos](docs/atajos-mac_es.md).

## Privacidad e incidencias

Sin servidores propios ni analítica: [política de privacidad](privacidad.md).

¿Algo falla? Abre una [incidencia](https://github.com/jopsis/InputStreamPlayer/issues)
con la versión, el aparato y lo que pasa, sin listas, claves ni tokens. En
Android, **Ajustes → Preferencias → Enviar registro** lo prepara ya limpio.

Este repositorio no publica código fuente, claves ni material de terceros.
