# InputStream Player

A player for **your own playlists** of live TV, movies and series on iPhone,
iPad, Apple TV, Mac and Android/Google TV. In app launchers it appears as
**ISPlayer**.

**[isplayer.joplabs.app](https://isplayer.joplabs.app)** · [Español](README.md)

> It ships no playlists, credentials or third-party keys. It is meant for
> content you are entitled to access.

This repository is for distribution only: **verifiable releases**,
documentation, sample playlists and issues.

## Downloads

| Platform | How to install |
|---|---|
| **iPhone and iPad** | With [SideStore](#sidestore): add the source and you get every version. |
| **Apple TV** | Unsigned IPA in the [latest release](https://github.com/jopsis/InputStreamPlayer/releases/latest); sign it with your own Apple account. |
| **Mac** (Apple Silicon) | ZIP in the [latest release](https://github.com/jopsis/InputStreamPlayer/releases/latest). Not notarized: [how to open it](docs/releases_en.md#apple-silicon-macs). |
| **Android and Google TV** | APK in the [latest release](https://github.com/jopsis/InputStreamPlayer/releases/latest); it updates itself afterwards. If unsure, take the *universal* one. |

Every file has its SHA-256. Detailed steps and verification:
[install guide](docs/releases_en.md). All versions in
[Releases](https://github.com/jopsis/InputStreamPlayer/releases).

### SideStore

[![Add to SideStore](https://img.shields.io/badge/SideStore-Add%20source-14B85C)](sidestore://source?url=https%3A%2F%2Fjopsis.github.io%2FInputStreamPlayer%2Fsidestore%2Fapps.json)

On the iPhone, tap the button; or in SideStore → Sources → **+**:
`https://jopsis.github.io/InputStreamPlayer/sidestore/apps.json`.
Install [SideStore](https://docs.sidestore.io/docs/installation/install) first
(ideally with [LiveContainer](https://livecontainer.github.io/docs/installation)).

> **With LiveContainer, turn on “Fix file picker”** in the app's settings, or
> importing a playlist from a file will do nothing.
> [More detail](docs/releases_en.md#required-livecontainer-setting-the-file-picker).

## What it does

- **Live TV** with a guide (XMLTV), remote-control zapping and catch-up.
- **Movies and series** from your lists, with “Continue” and watched marks.
- **Stremio add-ons** and **Trakt** lists; OpenSubtitles built in.
- **Favorites, recents and Multiview** (up to four channels at once).
- **Optional sync** through your own Google Drive and Trakt.
- **Encrypted playlists** `.ispl`: encrypt them with the
  [web encryptor](https://isplayer.joplabs.app/en/encrypt/) and share only the
  address and a key.
- **Android:** ExoPlayer and mpv engines, your choice.

More information and screenshots on the [website](https://isplayer.joplabs.app/en/).

## Formats

HLS (including SAMPLE-AES), DASH/MPD with CENC and Smooth Streaming, with
authorized ClearKey; direct MP4, MKV and TS. **M3U/M3U8**, **JSON** and VOD
catalog lists, by address or file, and encrypted `.ispl`. FairPlay, Widevine
and PlayReady licenses that need a license server are not supported.

- [Playlist format reference](docs/formatos-de-listas_en.md)
- Samples: [M3U](samples/inputstreamplayer.m3u) ·
  [JSON](samples/inputstreamplayer.json) ·
  [VOD catalog](samples/catalogo-vod.json)

## Mac

Two interfaces (Media center and Classic), hardware decoding, keyboard and
mouse. [Shortcuts](docs/atajos-mac_en.md).

## Privacy and issues

No servers of its own and no analytics: [privacy policy](privacidad.md).

Something wrong? Open an [issue](https://github.com/jopsis/InputStreamPlayer/issues)
with the version, the device and what happens, without playlists, keys or
tokens. On Android, **Settings → Preferences → Send log** prepares it already
cleaned.

This repository does not publish source code, keys or third-party material.
