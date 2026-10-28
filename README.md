# InputStream Player

A player for **your own playlists** of live TV, movies and series on iPhone,
iPad, Apple TV, Mac and Android/Google TV. In app launchers it appears as
**ISPlayer**.

**[isplayer.joplabs.app](https://isplayer.joplabs.app)** · [Español](README_es.md)

> It ships no playlists, credentials or third-party keys. It is meant for
> content you are entitled to access.

This repository is for distribution only: **verifiable releases**,
documentation, sample playlists and issues.

## Downloads

| Platform | How to install |
|---|---|
| **iPhone and iPad** | With [SideStore](#sidestore): add the source and you get every version. |
| **Apple TV** | Unsigned IPA in the [latest release](https://github.com/jopsis/InputStreamPlayer/releases/latest); sign it with your own Apple account. |
| **Mac** (Apple Silicon) | ZIP in the [latest release](https://github.com/jopsis/InputStreamPlayer/releases/latest). Not notarized: [how to open it](docs/releases.md#apple-silicon-macs). |
| **Android and Google TV** | APK in the [latest release](https://github.com/jopsis/InputStreamPlayer/releases/latest); it updates itself afterwards. If unsure, take the *universal* one. |

Every file has its SHA-256. Detailed steps and verification:
[install guide](docs/releases.md). All versions in
[Releases](https://github.com/jopsis/InputStreamPlayer/releases).

### SideStore

[![Add to SideStore](https://img.shields.io/badge/SideStore-Add%20source-14B85C)](sidestore://source?url=https%3A%2F%2Fjopsis.github.io%2FInputStreamPlayer%2Fsidestore%2Fapps.json)

On the iPhone, tap the button; or in SideStore → Sources → **+**:
`https://jopsis.github.io/InputStreamPlayer/sidestore/apps.json`.
Install [SideStore](https://docs.sidestore.io/docs/installation/install) first
(ideally with [LiveContainer](https://livecontainer.github.io/docs/installation)).

> **With LiveContainer, turn on “Fix file picker”** in the app's settings, or
> importing a playlist from a file will do nothing.
> [More detail](docs/releases.md#required-livecontainer-setting-the-file-picker).

## What it does

- **Live TV** with a guide (XMLTV), remote-control zapping and catch-up.
- **Collections:** the movies and series from your lists in their own tab (it only appears when a list has them), filtered by movies or series and by group, with “Continue”, watched marks, favorites and recents.
- **Stremio add-ons** and **Trakt** lists; OpenSubtitles built in. Got a Plex server? The [Plexio](https://plexio.stream/) Stremio add-on works with it.
- **Picture in Picture** on iPhone, iPad, Mac and Android phones and tablets: keep watching in a floating window while you use other apps. On iPhone the sound keeps playing in the background.
- **Favorites, recents and Multiview** (up to four channels at once). Favorites — channels, movies and series — sync across your devices.
- **One card per channel across lists** (optional, off by default): the same channel from several lists shows once and you pick the source — with its format — when you play it.
- **Your categories, your order:** reorder the groups of your lists; it is remembered on each device.
- **Optional sync** through your own Google Drive and Trakt.
- **Encrypted playlists** `.ispl`: encrypt them with the
  [web encryptor](https://isplayer.joplabs.app/encrypt/) and share only the
  address and a key.
- **Android:** ExoPlayer and mpv engines, your choice.
- **English and Spanish** interface: it follows the system language (English if
  yours isn't available) and can be changed in Preferences.

More information and screenshots on the [website](https://isplayer.joplabs.app/).

## Formats

HLS (including SAMPLE-AES), DASH/MPD with CENC and Smooth Streaming, with
authorized ClearKey (written in the list or from a ClearKey license server);
direct MP4, MKV and TS. **M3U/M3U8**, **JSON**, OTT Navigator channel lists
(OTC) and VOD catalog lists, by address or file, and encrypted `.ispl`.
Widevine with a license server plays only on Android (ExoPlayer); FairPlay and
PlayReady are not supported.

- [Playlist format reference](docs/formatos-de-listas.md)
- Samples: [M3U](samples/inputstreamplayer.m3u) ·
  [JSON](samples/inputstreamplayer.json) ·
  [VOD catalog](samples/catalogo-vod.json)

## Mac

Two interfaces (Media center and Classic), hardware decoding, keyboard and
mouse. [Shortcuts](docs/atajos-mac.md).

## Privacy and issues

No servers of its own and no analytics: [privacy policy](privacidad.md).

Something wrong? Open an [issue](https://github.com/jopsis/InputStreamPlayer/issues)
with the version, the device and what happens, without playlists, keys or
tokens. On Android, **Settings → Preferences → Send log** prepares it already
cleaned.

This repository does not publish source code, keys or third-party material.
