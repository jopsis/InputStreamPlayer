# Releases

Public builds are released only from this repository's
[Releases](../../../releases) section.

InputStream Player is available for **iOS**, **tvOS**, and **macOS**. Each
release identifies the platforms it includes.

Each release includes:

- the IPA;
- a `.sha256` file with the IPA's SHA-256 checksum;
- version, date, and release notes;
- any known compatibility requirements.

## Verification

Before installing, download the IPA and its `.sha256` file from the same
release and verify that they match. On macOS:

```sh
shasum -a 256 InputStreamPlayer-*.ipa
```

The output must exactly match the published checksum. Do not install files
received through other channels or files whose checksum does not match.

## Installation

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
