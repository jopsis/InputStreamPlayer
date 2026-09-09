#!/usr/bin/env bash
# Regenera sidestore/apps.json (formato AltStore/SideStore source) a partir de
# las releases publicadas en GitHub. No sube ni firma nada: solo lee metadatos
# públicos ya publicados (gh release view) y escribe el JSON local.
#
# Uso:
#   Tras publicar una release nueva en GitHub (con el IPA de iOS sin firmar y
#   su .sha256, como ya se hace a mano):
#     sidestore/update-source.sh
#     git add sidestore/apps.json
#     git commit -m "sidestore: actualiza apps.json para vX.Y.Z"
#     git push
#
# Requiere: gh (autenticado), jq.
set -euo pipefail

repo="jopsis/InputStreamPlayer"
source_url="https://jopsis.github.io/InputStreamPlayer/sidestore/apps.json"
icon_url="https://jopsis.github.io/InputStreamPlayer/assets/icon.png"
# Versión mínima de iOS declarada por el target Xcode
# (Apps/InputStreamPlayerIOS, IPHONEOS_DEPLOYMENT_TARGET). Actualizar aquí si
# cambia el deployment target del proyecto.
min_os_version="16.0"

if ! command -v gh >/dev/null 2>&1; then
  echo "error: falta 'gh' (GitHub CLI)" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "error: falta 'jq'" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out_file="$script_dir/apps.json"

tags="$(gh release list --repo "$repo" --json tagName,isDraft,isPrerelease \
  --jq '[.[] | select(.isDraft == false and .isPrerelease == false) | .tagName] | join("\n")')"

if [[ -z "$tags" ]]; then
  echo "error: no se encontraron releases publicadas en $repo" >&2
  exit 1
fi

versions_json="[]"
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  release_json="$(gh release view "$tag" --repo "$repo" \
    --json tagName,publishedAt,body,assets)"

  ipa_entry="$(jq -c '
    .assets
    | map(select(.name | test("^InputStreamPlayer-iOS-.*-unsigned\\.ipa$")))
    | first
  ' <<<"$release_json")"

  if [[ "$ipa_entry" == "null" ]]; then
    echo "aviso: $tag no tiene IPA de iOS sin firmar adjunto, se omite" >&2
    continue
  fi

  version_entry="$(jq -n \
    --arg version "${tag#v}" \
    --arg date "$(jq -r '.publishedAt' <<<"$release_json" | cut -dT -f1)" \
    --arg downloadURL "$(jq -r '.url' <<<"$ipa_entry")" \
    --argjson size "$(jq -r '.size' <<<"$ipa_entry")" \
    --arg sha256 "$(jq -r '.digest // "" | sub("^sha256:"; "")' <<<"$ipa_entry")" \
    --arg minOSVersion "$min_os_version" \
    --arg localizedDescription "$(jq -r '.body' <<<"$release_json")" \
    '{
      version: $version,
      date: $date,
      downloadURL: $downloadURL,
      size: $size,
      minOSVersion: $minOSVersion
    }
    + (if $sha256 != "" then {sha256: $sha256} else {} end)
    + (if $localizedDescription != "" then {localizedDescription: $localizedDescription} else {localizedDescription: ("Versión " + $version + ".")} end)
  ')"

  versions_json="$(jq -c --argjson v "$version_entry" '. + [$v]' <<<"$versions_json")"
done <<<"$tags"

# Orden cronológico inverso (más reciente primero): AltStore/SideStore
# muestran como "latest" la primera versión de la lista cuyo min/maxOSVersion
# sea compatible con el dispositivo.
versions_json="$(jq -c 'sort_by(.date) | reverse' <<<"$versions_json")"

jq -n \
  --arg name "InputStream Player" \
  --arg identifier "com.InputStreamPlayer.sidestore-source" \
  --arg sourceURL "$source_url" \
  --arg appName "InputStream Player" \
  --arg bundleIdentifier "com.InputStreamPlayer" \
  --arg developerName "jopsis" \
  --arg subtitle "Reproductor HLS/DASH/Smooth Streaming con ClearKey raw-key" \
  --arg localizedDescription "Reproductor nativo para iOS/tvOS/macOS de listas HLS, DASH/MPD y Microsoft Smooth Streaming (ISML), con soporte ClearKey/raw-key para el contenido autorizado por el usuario. No implementa FairPlay, Widevine ni PlayReady." \
  --arg iconURL "$icon_url" \
  --arg tintColor "14B85C" \
  --argjson versions "$versions_json" \
  '{
    name: $name,
    identifier: $identifier,
    sourceURL: $sourceURL,
    apps: [
      {
        name: $appName,
        bundleIdentifier: $bundleIdentifier,
        developerName: $developerName,
        subtitle: $subtitle,
        localizedDescription: $localizedDescription,
        iconURL: $iconURL,
        tintColor: $tintColor,
        versions: $versions
      }
    ],
    news: []
  }' > "$out_file"

echo "Escrito $out_file con $(jq '.apps[0].versions | length' "$out_file") versión(es)."
