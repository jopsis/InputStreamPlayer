# Playlist formats

InputStream Player imports UTF-8 encoded M3U/M3U8 and JSON playlists. A
playlist can contain clear channels and channels with a ClearKey/raw key; keys
are optional and must never be shared without the content owner's permission.

## M3U / M3U8

Declare each channel with `#EXTINF` and its URL on the next line. The app reads
the `tvg-logo` and `group-title` attributes. `tvg-id` can remain in the
playlist as metadata for other clients.

```m3u
#EXTM3U
#EXTINF:-1 tvg-id="demo-channel" tvg-logo="https://example.invalid/logo.png" group-title="Demo",Demo Channel
https://example.invalid/live/playlist.m3u8
```

Use Kodi's `inputstream.adaptive` convention before the URL to declare the
manifest type or a ClearKey:

```m3u
#EXTINF:-1 group-title="Demo",DASH channel with ClearKey
#KODIPROP:inputstream.adaptive.manifest_type=mpd
#KODIPROP:inputstream.adaptive.license_type=clearkey
#KODIPROP:inputstream.adaptive.license_key=00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100
https://example.invalid/channel/manifest.mpd
```

Supported `manifest_type` values:

| Value | Format |
| --- | --- |
| `hls` | HLS, including SAMPLE-AES with an authorized key |
| `mpd` | DASH / MPD with an authorized ClearKey/raw key |
| `ism` | Smooth Streaming (`.ism`/`.isml`) with an authorized ClearKey/raw key |

Keys use `KID:KEY`, with both values encoded as 16-byte hexadecimal strings
(32 hexadecimal characters each). `#EXTVLCOPT:http-user-agent=` can set a user
agent; `inputstream.adaptive.stream_headers` can set HTTP headers.

## JSON

The flat format is an array of channels. `name` and `url` are required;
`key`, `group`, `logo`, and `user_agent` are optional.

```json
[
  {
    "name": "Demo Channel",
    "url": "https://example.invalid/live/playlist.m3u8",
    "key": "00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100",
    "tvg_id": "demo-channel",
    "group": "Demo",
    "logo": "https://example.invalid/demo-channel.png"
  }
]
```

`key` uses the same `KID:KEY` syntax as M3U. `tvg_id` is accepted as extra
metadata for compatibility with existing playlists; the app safely ignores
fields it does not need.

The grouped schema is also supported: each group declares `name`, an optional
`logo`, and `samples`; each sample can declare `name`, `uri`, `logo`, `kid`,
`key`, and `user_agent`.

See the complete files in [samples](../samples/).

## Public demonstrations

The M3U sample includes public Unified Streaming streams and an Axinom
ClearKey test vector. They are provided to test app compatibility, not as a
guarantee of availability or a source of content. Only add keys and URLs that
you may legally use and redistribute.

