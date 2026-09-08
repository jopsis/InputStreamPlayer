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
