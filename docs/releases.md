# Releases

Las builds públicas se publican exclusivamente desde la sección
[Releases](https://github.com/jopsis/InputStreamPlayer/releases) de este
repositorio. La más reciente está siempre en
[releases/latest](https://github.com/jopsis/InputStreamPlayer/releases/latest).

InputStream Player está disponible para **iOS**, **tvOS**, **macOS** (Mac con
Apple Silicon, mediante PlayCover) y **Android** (móvil, Google TV y Android
TV). En los cajones de aplicaciones aparece como **ISPlayer**. Cada release
incluye (`X.Y.Z` es la versión y `N`, el número de build):

- `InputStreamPlayer-iOS-X.Y.Z-N-unsigned.ipa`: iPhone y iPad (SideStore/LiveContainer);
- `InputStreamPlayer-tvOS-X.Y.Z-N-unsigned.ipa`: Apple TV;
- `InputStreamPlayer-macOS-PlayCover-X.Y.Z-N.ipa`: Mac con Apple Silicon, con
  PlayCover y experiencia limitada (ver más abajo);
- `InputStreamPlayer-Android-arm64-X.Y.Z-N.apk`: Android de 64 bits (móviles y
  teles modernas);
- `InputStreamPlayer-Android-armv7-X.Y.Z-N.apk`: Android de 32 bits (p. ej.
  Chromecast con Google TV);
- `InputStreamPlayer-Android-universal-X.Y.Z-N.apk`: los dos anteriores en uno;
- un fichero `.sha256` con la suma SHA-256 de cada IPA y APK;
- la versión, fecha y notas de cambio;
- cualquier requisito de compatibilidad conocido.

## Verificación

Antes de instalar, descarga el IPA o el APK y su fichero `.sha256` desde la
misma release y comprueba que coinciden:

```sh
# macOS
shasum -a 256 InputStreamPlayer-*.ipa
# Linux
sha256sum InputStreamPlayer-*.apk
# Windows (PowerShell)
Get-FileHash InputStreamPlayer-*.apk -Algorithm SHA256
```

El resultado debe ser idéntico al checksum publicado. No instales archivos
recibidos por canales distintos de esta release o cuyo checksum no coincida.

## Instalación en iPhone y iPad

InputStream Player se instala a través de **SideStore** y se ejecuta dentro de
**LiveContainer**. Antes de descargar una release, configura ambas herramientas
siguiendo su documentación oficial:

- [Guía de instalación de SideStore](https://docs.sidestore.io/docs/installation/install)
- [Guía de instalación de LiveContainer con SideStore](https://livecontainer.github.io/docs/installation)

Después, descarga la IPA y su checksum desde esta release, verifica el archivo
e impórtalo en LiveContainer. Consulta la guía oficial de LiveContainer para
sus requisitos, compatibilidad y pasos de importación.

### Ajuste obligatorio en LiveContainer: el selector de archivos

Si vas a añadir listas con **«Desde un fichero» → «Elegir fichero…»**, activa
antes este ajuste o esa opción no funcionará:

> LiveContainer → ajustes **de InputStream Player** (no los generales) →
> **«Corregir selector de archivos»** *(Fix File Picker)*

Sin él, el síntoma es muy concreto: el selector se abre con normalidad, se ven
los archivos y los recientes, pero al pulsar «Abrir» no pasa nada y no se
importa ninguna lista.

No es un fallo de InputStream Player. El selector de archivos de iOS es un
servicio aparte del sistema, y entrega el archivo comprobando la identidad de
la app que lo pidió. LiveContainer ejecuta la app bajo su propia identidad, así
que esa comprobación no cuadra y el sistema no entrega nada. LiveContainer trae
la corrección, pero **viene desactivada** salvo que el propio LiveContainer se
esté ejecutando bajo SideStore. Por eso quien instala con SideStore no se
encuentra con esto y quien usa LiveContainer directamente sí.

Si con ese ajuste sigue sin funcionar, prueba también
**«(Heredado) Corregir Selector de archivos»**, que ataca el mismo problema de
otra forma: copia el archivo elegido a la bandeja de entrada de la app.

Mientras tanto, las otras dos formas de añadir una lista no se ven afectadas y
funcionan igual: **desde una URL** y **crear una lista a mano**. Si tienes la
lista en un archivo y no quieres tocar ajustes, súbela a cualquier sitio que
dé un enlace directo y añádela por URL.

Con el [source de SideStore](../README.md#añadir-inputstream-player-como-source-de-sidestore)
no hace falta descargar nada a mano: las versiones nuevas aparecen en SideStore.

## Apple TV

La IPA `InputStreamPlayer-tvOS-X.Y.Z-N-unsigned.ipa` va sin firmar. SideStore no
instala apps de Apple TV: hay que firmarla con tu propia cuenta de Apple e
instalarla con la herramienta que uses para ello.

## Android (móvil, Google TV y Android TV)

La release incluye tres APKs:

- `InputStreamPlayer-Android-arm64-X.Y.Z-N.apk`: móviles y teles modernas de 64 bits.
- `InputStreamPlayer-Android-armv7-X.Y.Z-N.apk`: teles de 32 bits, como el
  Chromecast con Google TV.
- `InputStreamPlayer-Android-universal-X.Y.Z-N.apk`: vale para los dos; ocupa
  más. Si no sabes cuál es el tuyo, usa este.

Descarga el APK adecuado para tu aparato, verifica su checksum `.sha256` y
instálalo permitiendo aplicaciones de orígenes desconocidos si el sistema lo
pide. En Google TV o Android TV puedes usar un navegador, un pendrive o `adb`.

### Actualizaciones

Después de la primera instalación no hace falta volver aquí: la app busca
versiones nuevas sola y también a mano, en **Ajustes → Buscar
actualizaciones**. Descarga el APK de tu aparato, comprueba su SHA-256 contra el
publicado en la release y abre el instalador del sistema; el progreso se ve en
esa misma fila.

### «La aplicación no se ha instalado debido a un conflicto con un paquete»

Significa que en el aparato hay otra copia de la app firmada con una clave
distinta (por ejemplo, una versión de pruebas), aunque no se vea: puede estar
instalada en **otro perfil** de Google TV. Todas las releases de este
repositorio van firmadas con la misma clave, así que entre ellas no pasa.

Desinstálala desde Ajustes → Aplicaciones (mira también en los demás perfiles)
o, con `adb`, para todos los perfiles a la vez:

```sh
adb uninstall com.inputstreamplayer
```

Al desinstalar se borran los datos locales de la app. Las fuentes por URL, los
ajustes y lo visto vuelven al iniciar sesión otra vez en Google Drive, si
usabas la sincronización; las listas añadidas desde un fichero hay que volver a
añadirlas.

## Mac con Apple Silicon (PlayCover)

La IPA `InputStreamPlayer-macOS-PlayCover-….ipa` es la misma app de iPhone,
firmada para que [PlayCover](https://playcover.io) la acepte. Verifícala como
cualquier otra y arrástrala a PlayCover.

Tiene **experiencia limitada**:

- Solo Mac con **Apple Silicon** (M1 o posterior); en Mac con Intel no funciona.
- Es una app de iPhone/iPad en una ventana, pensada para pantalla táctil.
- Si algún botón o menú no responde, desactiva el **mapeo de teclas** de
  PlayCover para esta app (clic derecho sobre la app en PlayCover → Ajustes).
