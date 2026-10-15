# Formatos de listas

InputStream Player importa listas M3U/M3U8 y JSON codificadas en UTF-8. Una
lista puede contener canales claros y canales con ClearKey/raw-key; las claves
son opcionales y nunca deben compartirse sin autorización del titular del
contenido.

## M3U / M3U8

Cada canal se declara con `#EXTINF` y una URL en la línea siguiente. Se
reconocen los atributos `tvg-logo` y `group-title`. `tvg-id` puede conservarse
como metadato de la lista para otros clientes.

```m3u
#EXTM3U
#EXTINF:-1 tvg-id="canal-demo" tvg-logo="https://example.invalid/logo.png" group-title="Demo",Canal Demo
https://example.invalid/directo/playlist.m3u8
```

Para indicar el tipo de manifiesto o una clave ClearKey se usa la convención de
`inputstream.adaptive` de Kodi antes de la URL:

```m3u
#EXTINF:-1 group-title="Demostración",Canal DASH con ClearKey
#KODIPROP:inputstream.adaptive.manifest_type=mpd
#KODIPROP:inputstream.adaptive.license_type=clearkey
#KODIPROP:inputstream.adaptive.license_key=00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100
https://example.invalid/canal/manifest.mpd
```

Valores admitidos de `manifest_type`:

| Valor | Formato |
| --- | --- |
| `hls` | HLS, incluido SAMPLE-AES con clave autorizada |
| `mpd` | DASH / MPD con ClearKey/raw-key autorizada |
| `ism` | Smooth Streaming (`.ism`/`.isml`) con ClearKey/raw-key autorizada |

La clave utiliza `KID:KEY`, ambos en hexadecimal y de 16 bytes (32 caracteres
hexadecimales cada uno). Si cada pista va cifrada con una clave distinta se
ponen varias parejas separadas por comas (`KID1:KEY1,KID2:KEY2`); también se
acepta el objeto JSON de ClearKey.

También se acepta `#EXTVLCOPT:http-user-agent=` para declarar un agente de
usuario y `inputstream.adaptive.stream_headers` para cabeceras HTTP, con la
forma `Nombre=valor&Otro=valor`:

```m3u
#KODIPROP:inputstream.adaptive.stream_headers=X-Token=abc123&Referer=https://example.invalid/
```

### Películas y series (bajo demanda)

Una lista puede mezclar canales en directo con películas y episodios. Los que
son bajo demanda aparecen en **Emisiones → Bajo demanda**, no en el directo.
Como el M3U no tiene un campo para eso, se deduce de lo que dice cada entrada,
por este orden:

1. **El tipo declarado:** `tvg-type`, `type`, `media-type` o `group-type` con
   `movie`, `series`, `vod`, `episode`… (o `live` para forzar directo).
2. **La ruta de Xtream Codes:** `/movie/…` y `/series/…` son bajo demanda;
   `/live/…`, directo.
3. **La extensión:** `.mp4`, `.mkv`, `.avi`, `.mov`… son ficheros de vídeo.
4. **La duración del `#EXTINF`:** los canales llevan `-1`; una duración de
   dos minutos o más se toma como película.

El nombre del grupo no cuenta: hay canales en directo en grupos que se llaman
«Cine» o «Series».

Los episodios se agrupan por serie y temporada a partir del nombre:
`Serie S01E02`, `Serie.s1.e2`, `Serie - T01E02` o `Serie 1x02`.

```m3u
#EXTINF:120 tvg-type="movie" tvg-logo="https://example.invalid/poster.jpg" group-title="Películas",Película Demo
https://example.invalid/vod/pelicula-demo.mp4
#EXTINF:-1 tvg-type="series" group-title="Series",Serie Demo S01E01
https://example.invalid/vod/serie-demo/s01e01.mkv
```

## JSON

El formato plano es un array de canales. Los campos requeridos son `name` y
`url`; los demás son opcionales:

| Campo | Para qué sirve |
| --- | --- |
| `key` | Clave ClearKey, con las mismas formas que `license_key` del M3U |
| `group` | Grupo del canal |
| `logo` | Logotipo |
| `tvg_id` | Identificador del canal en la guía |
| `user_agent` | Agente de usuario para pedir el vídeo |
| `type` | `movie`, `episode`, `series`… para contenido bajo demanda; `live` para directo |
| `serie_name`, `season`, `episode` | De qué serie, temporada y episodio es |
| `catchup_url`, `catchup_key`, `catchup_days`… | Ver [Catchup](#catchup) |

```json
[
  {
    "name": "Canal Demo",
    "url": "https://example.invalid/directo/playlist.m3u8",
    "key": "00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100",
    "tvg_id": "canal-demo",
    "group": "Demo",
    "logo": "https://example.invalid/canal-demo.png"
  }
]
```

`key` sigue la misma sintaxis `KID:KEY` de M3U. `tvg_id` se permite como
metadato adicional para mantener compatibilidad con listas existentes; la
aplicación ignora de forma segura los campos que no necesita.

También se admite un esquema agrupado: cada grupo define `name`, `logo`
opcional y `samples`; cada sample declara `name`, `uri`, `logo`, `kid`, `key`
y `user_agent` opcionales.

Consulta los ficheros completos en [samples](../samples/).

## Catálogos de películas y series (JSON)

Para contenido bajo demanda con ficha completa hay un tercer esquema JSON: un
array de títulos (o un único título). Es el mismo formato que el
[«Media library file» de OTT Navigator](https://ottnav.github.io/faq.html#media-library-file-json),
así que sus listas sirven tal cual. Todo lo que contiene va a **Bajo
demanda**. Una **película** lleva `video` (o `videos`, una lista de
versiones); una **serie** lleva `seasons`.

```json
[
  {
    "name": "Película Demo",
    "category": "Películas",
    "trailer": "https://example.invalid/trailers/pelicula-demo.mpd",
    "video": "https://example.invalid/vod/pelicula-demo/manifest.mpd",
    "drm": "clearkey",
    "drmkey": "00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100",
    "headers": "X-Token=abc123",
    "info": {
      "poster": "https://example.invalid/posters/pelicula-demo.jpg",
      "bg": "https://example.invalid/fondos/pelicula-demo.jpg",
      "plot": "Sinopsis de la película.",
      "rating": "7.4",
      "year": "2025",
      "genre": ["Drama", "Aventura"],
      "cast": ["Actriz Uno", "Actor Dos"],
      "director": ["Directora Demo"],
      "country": ["España"],
      "duration": 6540
    }
  },
  {
    "name": "Serie Demo",
    "category": "Series",
    "info": { "plot": "Sinopsis de la serie entera.", "year": "2026", "genre": "Comedia" },
    "seasons": [
      {
        "season": 1,
        "episodes": [
          {
            "episode": 1,
            "name": "El principio",
            "video": "https://example.invalid/vod/serie-demo/s01e01.m3u8",
            "info": { "plot": "Sinopsis del episodio.", "duration": 47 }
          }
        ]
      }
    ]
  }
]
```

| Campo | Para qué sirve |
| --- | --- |
| `name` | Título |
| `category` | Grupo en el que aparece (Películas, Series…) |
| `video` | Dirección del vídeo (HLS, DASH, Smooth o fichero) |
| `videos` | La película como lista de versiones, cada una con su `video`, `drm`, `drmkey`, `headers` e `info`. Se reproduce la primera que tenga `video` |
| `seasons` | Temporadas: `season` (número) y `episodes`, cada uno con `episode`, `name`, `video`, `drm`, `drmkey`, `headers` e `info`. Sin números, se numeran por su posición (1, 2, 3…) |
| `drm` | `clearkey` si va cifrado; sin él, se reproduce en claro |
| `drmkey` | Clave en la forma `KID:KEY` (o varias, separadas por comas) |
| `headers` | Cabeceras HTTP, como `Nombre=valor&Otro=valor` o como objeto (`{"User-Agent": "…"}`) |
| `trailer` | Tráiler: una dirección de vídeo, o de YouTube (o solo el id del vídeo), que se abre en YouTube. Aparece el botón «Tráiler» en la ficha. También vale dentro de `info` |
| `info` | La ficha (ver abajo) |

Campos de `info`, todos opcionales:

| Campo | Contenido |
| --- | --- |
| `poster`, `bg` (o `backdrop`) | Cartel y fondo |
| `plot` | Sinopsis. En una serie, la de la serie; cada episodio puede traer la suya |
| `rating`, `year` | Valoración y año; valen como número o como texto |
| `genre`, `cast`, `director`, `country` | Una lista de nombres o un texto con comas |
| `duration` | En minutos (`47`) o en segundos (`3420`): por encima de 400 se toma como segundos |

La lista es tolerante: los campos que no se usan se ignoran, un valor vacío o a
cero (`"rating": "0"`, `"plot": ""`) cuenta como que no se sabe, y un título,
temporada o episodio que no se pueda leer se salta sin tumbar el resto. Un
episodio hereda de la serie lo que no traiga (año, géneros, reparto…), y si no
tiene `name` se llama «Episodio N».

Como en OTT Navigator, también se admiten:

- **Textos por idioma:** `"name:es": "…"` sustituye a `name` si el aparato
  está en ese idioma (vale para cualquier campo).
- **BASE64:** un elemento técnico `{ "base64": "name,video" }` en la lista
  dice qué campos van codificados (sin relleno); `*` marca todos los textos.

`drm` solo admite `clearkey`: Widevine y otros con servidor de licencias no.

Ejemplo completo en [samples/catalogo-vod.json](../samples/catalogo-vod.json).

## Guía de programación (EPG)

La aplicación empareja cada canal con su programación de una guía XMLTV. El
emparejado usa primero `tvg-id` y, si no cuadra, el nombre del canal
normalizado, así que conviene declarar `tvg-id` con el mismo identificador que
use la guía.

Una lista puede declarar su guía en la cabecera `#EXTM3U`, con `x-tvg-url`
(también se aceptan `url-tvg` y `tvg-url`). Varias guías van separadas por
comas. La aplicación ofrece darla de alta; no la descarga sin permiso, porque
suelen ser decenas de megas.

```m3u
#EXTM3U x-tvg-url="https://example.invalid/guia.xml.gz"
```

Se admiten guías sin comprimir y con gzip.

## Catchup

El catchup permite ver un programa que ya se emitió. La aplicación necesita dos
cosas: la **guía**, que dice a qué hora empezó y terminó cada programa, y la
declaración del **archivo** en la lista, que dice a qué dirección hay que
pedirlo.

### M3U

Los atributos van en la línea `#EXTINF` y también valen en la cabecera
`#EXTM3U`, donde sirven de valor por defecto para toda la lista: un canal solo
tiene que declarar lo que cambie.

| Atributo | Para qué sirve |
| --- | --- |
| `catchup` (o `catchup-type`) | Modo: `default`, `append` o `shift`. Por omisión, `default` |
| `catchup-source` | La dirección del archivo (`default`) o el trozo de consulta que se añade a la del canal (`append`) |
| `catchup-days` | Días que guarda el archivo. Si no se declara se suponen 8 |
| `catchup-correction` | Corrección en horas, para archivos que no van sincronizados con la guía |
| `timeshift`, `tvg-rec`, `catchup-time` | Formas antiguas de declarar los días de archivo |

Modos:

- **`default`**: `catchup-source` es la dirección entera.
- **`append`**: `catchup-source` se le pega a la URL del canal, arreglando el
  separador (`?` o `&`) según haga falta.
- **`shift`**: no hace falta `catchup-source`; se le añade a la URL del canal
  `?utc={utc}&lutc={lutc}`.

### Marcadores de `catchup-source`

Se sustituyen por el momento del programa elegido. Las horas se calculan en
**UTC**.

| Marcador | Valor |
| --- | --- |
| `{utc}` · `${start}` | Inicio del programa, en segundos desde el epoch |
| `{utcend}` · `${end}` | Fin del programa |
| `{lutc}` · `${now}` · `${timestamp}` | Momento actual |
| `{duration}` · `{duration:X}` | Duración en segundos, o dividida entre X |
| `{offset}` · `{offset:X}` | Segundos transcurridos desde el inicio, o divididos entre X |
| `{Y}` `{m}` `{d}` `{H}` `{M}` `{S}` | Partes de la fecha de inicio, con ceros por delante |
| `{utc:Ymd-H-M}` · `${end:YmdHM}` | Fecha compuesta: las letras `YmdHMS` se sustituyen y lo demás pasa como separador |
| `{start_iso}` · `{end_iso}` · `{now_iso}` | Fecha ISO-8601 en UTC: `2026-09-21T09:30:00Z` |

Los tres últimos no son estándar: ningún reproductor los define, y lo corriente
es componer la fecha a mano con `{Y}-{m}-{d}T{H}:{M}:{S}Z`, que también se
acepta. Existen porque hay archivos que piden la hora en esa forma y escribirla
a mano es una errata esperando a pasar.

Lo que no se reconozca se deja tal cual, así que una dirección con llaves por
otros motivos no se estropea.

**Si `catchup-source` no lleva ningún marcador de tiempo**, se le añade
`start_time` y `end_time` en ISO. Es lo que hace falta para los archivos que
solo publican la dirección base: sin la ventana no saben qué servir.

### Clave propia del archivo

El archivo suele ir cifrado con una clave distinta a la del directo. Se declara
con un `#KODIPROP` propio o con un atributo, lo que resulte más cómodo:

```
#KODIPROP:inputstream.adaptive.catchup_license_key=KID:KEY
#KODIPROP:inputstream.adaptive.catchup_manifest_type=ism
```

o, en la línea `#EXTINF`, `catchup-key="KID:KEY"` y
`catchup-manifest-type="ism"`. Acepta las mismas formas que
`inputstream.adaptive.license_key`: `kid:key`, varias parejas separadas por
comas y el objeto JSON.

Sin clave propia se usa la del directo. Una clave de catchup mal formada deja
al canal sin archivo, pero **no** sin directo.

`catchup-manifest-type` solo hace falta cuando el archivo usa otro protocolo
que el directo; si no se declara, se deduce de la dirección.

### Ejemplo completo

```m3u
#EXTM3U x-tvg-url="https://example.invalid/guia.xml.gz"

#EXTINF:-1 tvg-id="canal-demo" group-title="Demo" catchup="default" catchup-days="8" catchup-source="https://example.invalid/archivo/canal-demo/Manifest?device_profile=mss&start_time={start_iso}&end_time={end_iso}",Canal Demo
#KODIPROP:inputstream.adaptive.manifest_type=ism
#KODIPROP:inputstream.adaptive.license_type=clearkey
#KODIPROP:inputstream.adaptive.license_key=00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100
#KODIPROP:inputstream.adaptive.catchup_license_key=aabbccddeeff00112233445566778899:99887766554433221100ffeeddccbbaa
https://example.invalid/directo/canal-demo/Manifest
```

En modo `append`, lo mismo se escribe así:

```m3u
#EXTINF:-1 catchup="append" catchup-days="7" catchup-source="?utc={utc}&utcend={utcend}",Canal Demo
https://example.invalid/directo/canal-demo/manifest.mpd
```

### JSON

En el esquema plano, los campos de catchup son opcionales:

```json
[
  {
    "name": "Canal Demo",
    "url": "https://example.invalid/directo/canal-demo/Manifest",
    "key": "00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100",
    "tvg_id": "canal-demo",
    "group": "Demo",
    "catchup_url": "https://example.invalid/archivo/canal-demo/Manifest?device_profile=mss",
    "catchup_key": "aabbccddeeff00112233445566778899:99887766554433221100ffeeddccbbaa",
    "catchup_days": 8
  }
]
```

| Campo | Equivale a |
| --- | --- |
| `catchup_url` | `catchup-source` en modo `default` |
| `catchup_key` | `catchup_license_key` |
| `catchup_days` | `catchup-days` |
| `catchup_type` | `catchup` |
| `catchup_source` | `catchup-source`, si se prefiere el nombre del M3U |

En el ejemplo, `catchup_url` no lleva marcadores, así que la aplicación le
añade `start_time` y `end_time` en ISO. Un canal sin `catchup_url` (o con el
campo vacío) simplemente no ofrece archivo.

### Cuánto pasado se ve

El archivo del servidor y la guía son cosas distintas, y mandan las dos: solo
se puede ver un programa que el archivo guarde **y** que la guía liste.

La mayoría de guías XMLTV son de futuro y traen poco o ningún pasado. La
aplicación conserva los programas ya emitidos de cada refresco, así que el
pasado se va llenando día a día hasta los que declare `catchup-days`. Recién
instalada verás solo lo que traiga tu guía; el resto llega con los días.

## Demostraciones públicas

El sample M3U incluye transmisiones públicas de Unified Streaming y un vector
de prueba ClearKey de Axinom. Se ofrecen para comprobar la compatibilidad de la
aplicación, no como garantía de disponibilidad ni como fuente de contenido.
Solo añade a una lista claves y URLs que puedas usar y redistribuir legalmente.
