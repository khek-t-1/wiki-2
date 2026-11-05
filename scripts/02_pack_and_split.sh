#!/usr/bin/env bash
#
# Step 2 — har folder ko zip karo, zip ko 24 MB ke parts mein todo,
#          aur SHA256SUMS.txt + MANIFEST.csv banao.
#
#   bash scripts/02_pack_and_split.sh
#   DEST=/content/pnb_download PART_SIZE=24M bash scripts/02_pack_and_split.sh
#
# Output:
#   $DEST/zips/<folder>.zip              (original zips)
#   $DEST/parts/<folder>.zip.NN.part     (GitHub release ke liye parts)
#   $DEST/parts/SHA256SUMS.txt
#   $DEST/parts/MANIFEST.csv
#
# 24 MB kyun? GitHub repo mein 100 MB ki hard limit hai aur release assets ke liye
# bhi chhote parts resume/re-download ke liye behtar hain. PART_SIZE se badal sakte ho.
#
set -euo pipefail

DEST="${DEST:-/content/pnb_download}"
RAW="$DEST/raw"
ZIPS="$DEST/zips"
PARTS="$DEST/parts"
PART_SIZE="${PART_SIZE:-24M}"

[ -d "$RAW" ] || { echo "ERROR: $RAW nahi mila — pehle scripts/01_download_gofile.sh chalao"; exit 1; }
mkdir -p "$ZIPS" "$PARTS"

command -v zip >/dev/null 2>&1 || { apt-get update -qq && apt-get install -y -qq zip >/dev/null; }

echo "=== zipping (level 1 — parquet/arrow pehle se compressed hain) ==="
for dir in "$RAW"/*/; do
  name=$(basename "$dir")
  zip_path="$ZIPS/$name.zip"
  if [ -f "$zip_path" ]; then
    echo "[skip] $name.zip exists"
    continue
  fi
  echo "--- $name"
  ( cd "$RAW" && zip -r -q -1 "$zip_path" "$name" )
  ls -lh "$zip_path" | awk '{print "    "$5"  "$9}'
done

echo
echo "=== splitting into $PART_SIZE parts ==="
rm -f "$PARTS"/*.part
for z in "$ZIPS"/*.zip; do
  base=$(basename "$z")
  split -b "$PART_SIZE" -d -a 2 --additional-suffix=.part "$z" "$PARTS/$base."
  printf "  %-38s %s parts\n" "$base" "$(ls "$PARTS/$base".*.part 2>/dev/null | wc -l)"
done

echo
echo "=== checksums ==="
( cd "$PARTS" && sha256sum *.part > SHA256SUMS.txt )
( cd "$ZIPS"   && sha256sum *.zip  > SHA256SUMS_zips.txt )

python3 - "$ZIPS" "$PARTS" <<'PY'
import csv, hashlib, sys, pathlib
zips, parts = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
rows = []
for z in sorted(zips.glob("*.zip")):
    h = hashlib.sha256()
    with open(z, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    p = sorted(parts.glob(z.name + ".*.part"))
    rows.append({
        "zip": z.name,
        "bytes": z.stat().st_size,
        "mb": round(z.stat().st_size / 1e6, 1),
        "parts": len(p),
        "sha256": h.hexdigest(),
    })
with open(parts / "MANIFEST.csv", "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["zip", "bytes", "mb", "parts", "sha256"])
    w.writeheader(); w.writerows(rows)
total = sum(r["bytes"] for r in rows)
print(f"{len(rows)} zips, {sum(r['parts'] for r in rows)} parts, {total/1e6:.1f} MB total")
PY

echo
echo "=== summary ==="
du -sh "$ZIPS" "$PARTS"
echo "Agla step: bash scripts/03_upload_release.sh"
