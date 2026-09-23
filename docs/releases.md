# Releases

Las builds públicas se publican exclusivamente desde la sección
[Releases](../../../releases) de este repositorio.

InputStream Player está disponible para **iOS**, **tvOS** y **macOS**. Cada
release indica las plataformas incluidas.

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
