#!/usr/bin/env bash
#
# Step 1 — Gofile se poora pnb bundle download karo.
#
#   bash scripts/01_download_gofile.sh
#   DEST=/content/pnb_download bash scripts/01_download_gofile.sh   # custom folder
#
# Zaroorat: python3 + gallery-dl  (script khud install kar leta hai)
# Net: koi login nahi chahiye — folders public hain.
#
# NOTE: root folder code (NvnvtGwy) jaan bujh kar skip kiya gaya hai, kyunke
# uske andar wohi 10 folders dobara hain -> 778 MB duplicate download ho jata.
# Documentation files repo ke pnb_datasets/ folder mein pehle se mojood hain.
#
set -uo pipefail

DEST="${DEST:-/content/pnb_download}"
RAW="$DEST/raw"
LOG="$DEST/download.log"
mkdir -p "$RAW"

# folder_name : gofile_code   (code = https://gofile.io/d/<CODE> ka aakhri hissa)
FOLDERS=(
  "01_Wikipedia_pnb_XML_dump:L7CwvZeR:237.9MB"
  "02_Wikipedia_pnb_HF_parquet:B2ROR22U:133.3MB"
  "03_Glot500_pnb_Arab:QF74JedQ:345.5MB"
  "04_FineWeb2_pnb_Arab:9o75K4s3:33.7MB"
  "05_GlotCC_V1_pnb_Arab:BGFD7emj:18.3MB"
  "06_OSCAR_pnb_open_mirrors:OAzZqJdF:6.3MB"
  "07_Leipzig_LCC_pnb:ESjUNlHP:1.7MB"
  "08_OPUS_parallel_pnb:gQZSE92X:1.1MB"
  "09_pnb_Wiktionary:FGq36ER0:0.8MB"
  "10_Tatoeba_pnb:vXUnoA5G:0.001MB"
)

echo "=== dest: $DEST ==="

# --- gallery-dl ---
if ! command -v gallery-dl >/dev/null 2>&1; then
  echo "gallery-dl install kar raha hoon..."
  pip install -q --upgrade gallery-dl || { echo "gallery-dl install fail"; exit 1; }
fi
gallery-dl --version

fail=0
for entry in "${FOLDERS[@]}"; do
  IFS=':' read -r name code size <<<"$entry"
  target="$RAW/$name"

  if [ -d "$target" ] && [ -n "$(ls -A "$target" 2>/dev/null)" ]; then
    echo "[skip] $name (already downloaded)"
    continue
  fi

  echo "=== $name  (https://gofile.io/d/$code  ~$size) ==="
  # 3 koshish; gallery-dl khud resume karta hai (--download-archive nahi, kyunke
  # incomplete files dobara try par continue hoti hain)
  ok=0
  for attempt in 1 2 3; do
    gallery-dl -d "$DEST/.gd" --retries 5 --timeout 60 \
      "https://gofile.io/d/$code" 2>&1 | tee -a "$LOG"
    got="$DEST/.gd/gofile/$code"
    if [ -d "$got" ] && [ -n "$(ls -A "$got" 2>/dev/null)" ]; then
      mkdir -p "$target"
      mv "$got"/* "$target"/ 2>/dev/null && rmdir "$got" 2>/dev/null
      ok=1
      break
    fi
    echo "  attempt $attempt fail — 10s baad dobara"
    sleep 10
  done

  if [ "$ok" -eq 1 ]; then
    n=$(find "$target" -type f | wc -l)
    sz=$(du -sh "$target" | cut -f1)
    echo "  -> OK: $n files, $sz"
  else
    echo "  -> FAIL: $name  (link expire ho gaya ho sakta hai — 10 din inactivity)"
    fail=$((fail+1))
  fi
done

echo
echo "=== summary ==="
du -sh "$RAW" 2>/dev/null
find "$RAW" -type f | wc -l | xargs echo "total files:"
[ "$fail" -gt 0 ] && echo "WARNING: $fail folder(s) fail hue — upar log dekho: $LOG"
echo "Agla step: bash scripts/02_pack_and_split.sh"
