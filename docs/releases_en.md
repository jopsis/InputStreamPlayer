# Releases

Public builds are released only from this repository's
[Releases](https://github.com/jopsis/InputStreamPlayer/releases) section. The
most recent one is always at
[releases/latest](https://github.com/jopsis/InputStreamPlayer/releases/latest).

InputStream Player is available for **iOS**, **tvOS**, **macOS** (Apple
Silicon Macs, through PlayCover), and **Android** (phone, Google TV and Android
TV). In app drawers it shows up as **ISPlayer**. Each release includes
(`X.Y.Z` is the version and `N` the build number):

- `InputStreamPlayer-iOS-X.Y.Z-N-unsigned.ipa`: iPhone and iPad (SideStore/LiveContainer);
- `InputStreamPlayer-tvOS-X.Y.Z-N-unsigned.ipa`: Apple TV;
- `InputStreamPlayer-macOS-PlayCover-X.Y.Z-N.ipa`: Apple Silicon Macs, with
  PlayCover and a limited experience (see below);
- `InputStreamPlayer-Android-arm64-X.Y.Z-N.apk`: 64-bit Android (modern phones
  and TVs);
- `InputStreamPlayer-Android-armv7-X.Y.Z-N.apk`: 32-bit Android (e.g.
  Chromecast with Google TV);
- `InputStreamPlayer-Android-universal-X.Y.Z-N.apk`: both of the above in one;
- a `.sha256` file with each IPA and APK's SHA-256 checksum;
- version, date, and release notes;
- any known compatibility requirements.

## Verification

Before installing, download the IPA or APK and its `.sha256` file from the
same release and verify that they match:

```sh
# macOS
shasum -a 256 InputStreamPlayer-*.ipa
# Linux
sha256sum InputStreamPlayer-*.apk
# Windows (PowerShell)
Get-FileHash InputStreamPlayer-*.apk -Algorithm SHA256
```

The output must exactly match the published checksum. Do not install files
received through other channels or files whose checksum does not match.

## Installing on iPhone and iPad

Install InputStream Player through **SideStore** and run it inside
**LiveContainer**. Before downloading a release, set up both tools using their
official documentation:

- [SideStore installation guide](https://docs.sidestore.io/docs/installation/install)
- [LiveContainer installation guide with SideStore](https://livecontainer.github.io/docs/installation)

Then download the IPA and its checksum from this release, verify the file, and
import it into LiveContainer. Refer to LiveContainer's official guide for its
requirements, compatibility, and import steps.

### Required LiveContainer setting: the file picker

If you plan to add playlists with **"From a file" -> "Choose file..."**, turn
this on first or that option will not work:

> LiveContainer -> settings **for InputStream Player** (not the global ones) ->
> **"Fix File Picker"**

Without it the symptom is very specific: the picker opens normally, you can see
your files and recents, but tapping "Open" does nothing and no playlist is
imported.

This is not an InputStream Player bug. The iOS file picker is a separate system
service, and it hands the file over by checking the identity of the app that
asked for it. LiveContainer runs the app under its own identity, so that check
does not match and the system hands nothing back. LiveContainer ships the fix,
but it is **off by default** unless LiveContainer itself is running under
SideStore. That is why people installing through SideStore never hit this and
people using LiveContainer directly do.

If it still fails with that setting on, try **"(Legacy) Fix File Picker"** too,
which tackles the same problem differently: it copies the chosen file into the
app's inbox.

In the meantime the other two ways to add a playlist are unaffected and work as
usual: **from a URL** and **creating a playlist by hand**. If your playlist is
in a file and you would rather not touch settings, upload it anywhere that
gives a direct link and add it by URL.

With the [SideStore source](../README_en.md#add-inputstream-player-as-a-sidestore-source)
you do not need to download anything by hand: new versions show up in SideStore.

## Apple TV

The `InputStreamPlayer-tvOS-X.Y.Z-N-unsigned.ipa` IPA is unsigned. SideStore
does not install Apple TV apps: you need to sign it with your own Apple account
and install it with the tool you use for that.

## Android (phone, Google TV and Android TV)

The release includes three APKs:

- `InputStreamPlayer-Android-arm64-X.Y.Z-N.apk`: modern 64-bit phones and TVs.
- `InputStreamPlayer-Android-armv7-X.Y.Z-N.apk`: 32-bit TVs, such as Chromecast
  with Google TV.
- `InputStreamPlayer-Android-universal-X.Y.Z-N.apk`: works on both; it is
  larger. If you are not sure which one you need, use this one.

Download the right APK for your device, verify its `.sha256` checksum, and
install it allowing apps from unknown sources if the system asks. On Google TV
or Android TV, use a browser, a USB drive, or `adb` to transfer and install it.

### Updates

After the first install you do not need to come back here: the app looks for
new versions by itself and by hand, under **Ajustes → Buscar
actualizaciones**. It downloads the APK for your device, checks its SHA-256
against the one published in the release, and opens the system installer;
progress shows on that same row.

### "App not installed as package conflicts with an existing package"

There is another copy of the app on the device signed with a different key
(for example, a test build), even if you cannot see it: it may be installed in
**another Google TV profile**. Every release in this repository is signed with
the same key, so this never happens between them.

Uninstall it from Settings → Apps (check the other profiles too) or, with
`adb`, for every profile at once:

```sh
adb uninstall com.inputstreamplayer
```

Uninstalling deletes the app's local data. URL sources, settings, and watch
history come back when you sign in to Google Drive again, if you were using
sync; playlists added from a file have to be added again.

## Apple Silicon Macs (PlayCover)

The `InputStreamPlayer-macOS-PlayCover-….ipa` IPA is the same iPhone app, signed
so that [PlayCover](https://playcover.io) accepts it. Verify it like any other
release file and drag it into PlayCover.

It offers a **limited experience**:

- Apple **Silicon** Macs only (M1 or later); it does not work on Intel Macs.
- It is an iPhone/iPad app in a window, designed for a touch screen.
- If a button or menu does not respond, turn off PlayCover's **keymapping** for
  this app (right-click the app in PlayCover → Settings).
