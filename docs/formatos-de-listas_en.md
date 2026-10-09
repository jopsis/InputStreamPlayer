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
(32 hexadecimal characters each). When each track is encrypted with a
different key, list several pairs separated by commas (`KID1:KEY1,KID2:KEY2`);
the ClearKey JSON object is accepted too.

`#EXTVLCOPT:http-user-agent=` can set a user agent, and
`inputstream.adaptive.stream_headers` can set HTTP headers, in the form
`Name=value&Other=value`:

```m3u
#KODIPROP:inputstream.adaptive.stream_headers=X-Token=abc123&Referer=https://example.invalid/
```

### Movies and series (on demand)

A playlist can mix live channels with movies and episodes. On-demand entries
show up under **Emisiones → Bajo demanda** (On demand), not in live TV. M3U has
no field for this, so it is worked out from what each entry says, in this
order:

1. **The declared type:** `tvg-type`, `type`, `media-type`, or `group-type` set
   to `movie`, `series`, `vod`, `episode`… (or `live` to force live).
2. **The Xtream Codes path:** `/movie/…` and `/series/…` are on demand;
   `/live/…` is live.
3. **The extension:** `.mp4`, `.mkv`, `.avi`, `.mov`… are video files.
4. **The `#EXTINF` duration:** channels use `-1`; a duration of two minutes or
   more is taken as a movie.

The group name does not count: there are live channels in groups called
"Movies" or "Series".

Episodes are grouped by series and season from their name: `Show S01E02`,
`Show.s1.e2`, `Show - T01E02`, or `Show 1x02`.

```m3u
#EXTINF:120 tvg-type="movie" tvg-logo="https://example.invalid/poster.jpg" group-title="Movies",Demo Movie
https://example.invalid/vod/demo-movie.mp4
#EXTINF:-1 tvg-type="series" group-title="Series",Demo Show S01E01
https://example.invalid/vod/demo-show/s01e01.mkv
```

## JSON

The flat format is an array of channels. `name` and `url` are required; the
rest are optional:

| Field | Purpose |
| --- | --- |
| `key` | ClearKey key, in the same forms as the M3U `license_key` |
| `group` | Channel group |
| `logo` | Logo |
| `tvg_id` | Channel identifier in the guide |
| `user_agent` | User agent used to request the video |
| `type` | `movie`, `episode`, `series`… for on-demand content; `live` for live |
| `serie_name`, `season`, `episode` | Which series, season, and episode it is |
| `catchup_url`, `catchup_key`, `catchup_days`… | See [Catch-up](#catch-up) |

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

## Movie and series catalogs (JSON)

For on-demand content with full details there is a third JSON schema: an
array of titles (or a single title). Everything in it goes to **Bajo demanda**
(On demand). A **movie** has `video` (or `videos`, a list of versions); a
**series** has `seasons`.

```json
[
  {
    "name": "Demo Movie",
    "category": "Movies",
    "trailer": "https://example.invalid/trailers/demo-movie.mpd",
    "video": "https://example.invalid/vod/demo-movie/manifest.mpd",
    "drm": "clearkey",
    "drmkey": "00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100",
    "headers": "X-Token=abc123",
    "info": {
      "poster": "https://example.invalid/posters/demo-movie.jpg",
      "bg": "https://example.invalid/backdrops/demo-movie.jpg",
      "plot": "Movie plot.",
      "rating": "7.4",
      "year": "2025",
      "genre": ["Drama", "Adventure"],
      "cast": ["Actress One", "Actor Two"],
      "director": ["Demo Director"],
      "country": ["Spain"],
      "duration": 6540
    }
  },
  {
    "name": "Demo Show",
    "category": "Series",
    "info": { "plot": "Plot of the whole series.", "year": "2026", "genre": "Comedy" },
    "seasons": [
      {
        "season": 1,
        "episodes": [
          {
            "episode": 1,
            "name": "The beginning",
            "video": "https://example.invalid/vod/demo-show/s01e01.m3u8",
            "info": { "plot": "Episode plot.", "duration": 47 }
          }
        ]
      }
    ]
  }
]
```

| Field | Purpose |
| --- | --- |
| `name` | Title |
| `category` | Group it appears in (Movies, Series…) |
| `video` | Video address (HLS, DASH, Smooth, or a file) |
| `videos` | The movie as a list of versions, each with its own `video`, `drm`, `drmkey`, `headers`, and `info`. The first one with a `video` is played |
| `seasons` | Seasons: `season` (number) and `episodes`, each with `episode`, `name`, `video`, `drm`, `drmkey`, `headers`, and `info` |
| `drm` | `clearkey` if encrypted; without it, it plays in the clear |
| `drmkey` | Key as `KID:KEY` (or several, separated by commas) |
| `headers` | HTTP headers, as `Name=value&Other=value` |
| `trailer` | A trailer address; adds a "Tráiler" button to the detail page |
| `info` | The details (see below) |

`info` fields, all optional:

| Field | Content |
| --- | --- |
| `poster`, `bg` | Poster and backdrop |
| `plot` | Plot. In a series, the series plot; each episode can carry its own |
| `rating`, `year` | Rating and year; numbers or text both work |
| `genre`, `cast`, `director`, `country` | A list of names or comma-separated text |
| `duration` | In minutes (`47`) or seconds (`3420`): above 400 it is taken as seconds |

The parser is lenient: unused fields are ignored, an empty or zero value
(`"rating": "0"`, `"plot": ""`) counts as unknown, and a title, season, or
episode that cannot be read is skipped without breaking the rest. An episode
inherits from the series whatever it lacks (year, genres, cast…), and without a
`name` it is called "Episodio N".

Complete example in [samples/catalogo-vod.json](../samples/catalogo-vod.json).

## Programme guide (EPG)

The app matches each channel against an XMLTV guide. Matching uses `tvg-id`
first and falls back to the normalized channel name, so declare `tvg-id` with
the same identifier the guide uses.

A playlist can declare its guide in the `#EXTM3U` header with `x-tvg-url`
(`url-tvg` and `tvg-url` are also accepted). Separate several guides with
commas. The app offers to add it; it never downloads one without permission,
because guides are usually tens of megabytes.

```m3u
#EXTM3U x-tvg-url="https://example.invalid/guide.xml.gz"
```

Plain and gzipped guides are both supported.

## Catch-up

Catch-up plays a programme that already aired. The app needs two things: the
**guide**, which says when each programme started and ended, and the **archive**
declaration in the playlist, which says where to request it.

### M3U

The attributes go on the `#EXTINF` line, and also work on the `#EXTM3U` header,
where they act as a default for the whole playlist: a channel only declares
what differs.

| Attribute | Purpose |
| --- | --- |
| `catchup` (or `catchup-type`) | Mode: `default`, `append` or `shift`. Defaults to `default` |
| `catchup-source` | The archive address (`default`) or the query fragment appended to the channel URL (`append`) |
| `catchup-days` | Days the archive keeps. Assumed to be 8 when absent |
| `catchup-correction` | Correction in hours, for archives not aligned with the guide |
| `timeshift`, `tvg-rec`, `catchup-time` | Legacy ways of declaring the archive length |

Modes:

- **`default`**: `catchup-source` is the whole address.
- **`append`**: `catchup-source` is glued onto the channel URL, fixing the
  separator (`?` or `&`) as needed.
- **`shift`**: no `catchup-source` needed; `?utc={utc}&lutc={lutc}` is appended
  to the channel URL.

### `catchup-source` placeholders

They expand to the moment of the chosen programme. Times are computed in
**UTC**.

| Placeholder | Value |
| --- | --- |
| `{utc}` · `${start}` | Programme start, in seconds since the epoch |
| `{utcend}` · `${end}` | Programme end |
| `{lutc}` · `${now}` · `${timestamp}` | Current moment |
| `{duration}` · `{duration:X}` | Duration in seconds, or divided by X |
| `{offset}` · `{offset:X}` | Seconds elapsed since the start, or divided by X |
| `{Y}` `{m}` `{d}` `{H}` `{M}` `{S}` | Parts of the start date, zero padded |
| `{utc:Ymd-H-M}` · `${end:YmdHM}` | Composed date: the letters `YmdHMS` are substituted and anything else passes through as a separator |
| `{start_iso}` · `{end_iso}` · `{now_iso}` | ISO-8601 date in UTC: `2026-09-21T09:30:00Z` |

The last three are not standard: no player defines them, and the usual way is
to compose the date by hand with `{Y}-{m}-{d}T{H}:{M}:{S}Z`, which is also
accepted. They exist because some archives want the time in that shape, and
writing it by hand is a typo waiting to happen.

Anything unrecognized is left untouched, so an address that contains braces for
other reasons is not mangled.

**If `catchup-source` carries no time placeholder at all**, `start_time` and
`end_time` are appended in ISO form. That is what archives which only publish
their base address need: without the window they do not know what to serve.

### The archive's own key

Archives are usually encrypted with a different key from the live channel.
Declare it with its own `#KODIPROP` or with an attribute, whichever is handier:

```
#KODIPROP:inputstream.adaptive.catchup_license_key=KID:KEY
#KODIPROP:inputstream.adaptive.catchup_manifest_type=ism
```

or, on the `#EXTINF` line, `catchup-key="KID:KEY"` and
`catchup-manifest-type="ism"`. It accepts the same forms as
`inputstream.adaptive.license_key`: `kid:key`, several comma-separated pairs,
and the JSON object.

Without its own key, the live one is used. A malformed catch-up key leaves the
channel without an archive, but **not** without its live stream.

`catchup-manifest-type` is only needed when the archive uses a different
protocol from the live stream; otherwise it is inferred from the address.

### Complete example

```m3u
#EXTM3U x-tvg-url="https://example.invalid/guide.xml.gz"

#EXTINF:-1 tvg-id="demo-channel" group-title="Demo" catchup="default" catchup-days="8" catchup-source="https://example.invalid/archive/demo-channel/Manifest?device_profile=mss&start_time={start_iso}&end_time={end_iso}",Demo Channel
#KODIPROP:inputstream.adaptive.manifest_type=ism
#KODIPROP:inputstream.adaptive.license_type=clearkey
#KODIPROP:inputstream.adaptive.license_key=00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100
#KODIPROP:inputstream.adaptive.catchup_license_key=aabbccddeeff00112233445566778899:99887766554433221100ffeeddccbbaa
https://example.invalid/live/demo-channel/Manifest
```

In `append` mode the same thing reads:

```m3u
#EXTINF:-1 catchup="append" catchup-days="7" catchup-source="?utc={utc}&utcend={utcend}",Demo Channel
https://example.invalid/live/demo-channel/manifest.mpd
```

### JSON

In the flat schema the catch-up fields are optional:

```json
[
  {
    "name": "Demo Channel",
    "url": "https://example.invalid/live/demo-channel/Manifest",
    "key": "00112233445566778899aabbccddeeff:ffeeddccbbaa99887766554433221100",
    "tvg_id": "demo-channel",
    "group": "Demo",
    "catchup_url": "https://example.invalid/archive/demo-channel/Manifest?device_profile=mss",
    "catchup_key": "aabbccddeeff00112233445566778899:99887766554433221100ffeeddccbbaa",
    "catchup_days": 8
  }
]
```

| Field | Equivalent to |
| --- | --- |
| `catchup_url` | `catchup-source` in `default` mode |
| `catchup_key` | `catchup_license_key` |
| `catchup_days` | `catchup-days` |
| `catchup_type` | `catchup` |
| `catchup_source` | `catchup-source`, if you prefer the M3U name |

In the example `catchup_url` carries no placeholders, so the app appends
`start_time` and `end_time` in ISO form. A channel without `catchup_url` (or
with an empty one) simply offers no archive.

### How far back you can watch

The server's archive and the guide are different things, and both have a say:
you can only watch a programme the archive keeps **and** the guide lists.

Most XMLTV guides look forward and carry little or no past. The app keeps the
already-aired programmes from each refresh, so the past fills in day by day up
to whatever `catchup-days` declares. Freshly installed you will only see what
your guide brings; the rest arrives with the days.

## Public demonstrations

The M3U sample includes public Unified Streaming streams and an Axinom
ClearKey test vector. They are provided to test app compatibility, not as a
guarantee of availability or a source of content. Only add keys and URLs that
you may legally use and redistribute.

