#!/usr/bin/env bash
#
# Ek hi command mein poora kaam: download -> zip+split -> release upload.
#
#   bash scripts/run_all.sh
#
# Env vars (sab optional):
#   REPO=khek-t-1/wiki-2      jis repo ki release banani hai
#   TAG=v1.0                  release tag
#   DEST=/content/pnb_download   data kahan rakhein (kam az kam ~2 GB free chahiye)
#   PART_SIZE=24M             parts ka size (aap ne 20-25 MB kaha tha)
#
# Har step dobara chalane par wahin se resume hota hai jahan chhoda tha.
#
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export REPO="${REPO:-khek-t-1/wiki-2}"
export TAG="${TAG:-v1.0}"
export DEST="${DEST:-/content/pnb_download}"
export PART_SIZE="${PART_SIZE:-24M}"

echo "repo=$REPO  tag=$TAG  dest=$DEST  part_size=$PART_SIZE"
mkdir -p "$DEST"

echo
echo "############ STEP 1/3 — Gofile se download ############"
bash "$HERE/01_download_gofile.sh" || { echo "step 1 fail"; exit 1; }

echo
echo "############ STEP 2/3 — zip + 24MB parts + checksums ############"
bash "$HERE/02_pack_and_split.sh" || { echo "step 2 fail"; exit 1; }

echo
echo "############ STEP 3/3 — GitHub release upload ############"
bash "$HERE/03_upload_release.sh"
rc=$?

echo
echo "############ KHATAM ############"
echo "release: https://github.com/$REPO/releases/tag/$TAG"
echo "local:   $DEST  (zips: $DEST/zips, parts: $DEST/parts)"
exit $rc
