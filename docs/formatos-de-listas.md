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
hexadecimales cada uno). También se acepta `#EXTVLCOPT:http-user-agent=` para
declarar un agente de usuario y `inputstream.adaptive.stream_headers` para
cabeceras HTTP.

## JSON

El formato plano es un array de canales. Los campos requeridos son `name` y
`url`; los campos `key`, `group`, `logo` y `user_agent` son opcionales.

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

## Demostraciones públicas

El sample M3U incluye transmisiones públicas de Unified Streaming y un vector
de prueba ClearKey de Axinom. Se ofrecen para comprobar la compatibilidad de la
aplicación, no como garantía de disponibilidad ni como fuente de contenido.
Solo añade a una lista claves y URLs que puedas usar y redistribuir legalmente.
