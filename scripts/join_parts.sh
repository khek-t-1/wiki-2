#!/usr/bin/env bash
#
# Parts ko wapas zip mein jodo aur verify karo.
#
#   bash scripts/join_parts.sh /content/pnb_download/parts
#
# Har `<name>.zip.NN.part` ka set mila kar `<name>.zip` banata hai,
# phir SHA256SUMS.txt se verify karta hai (agar mojood ho).
#
set -euo pipefail

DIR="${1:-/content/pnb_download/parts}"
[ -d "$DIR" ] || { echo "usage: bash scripts/join_parts.sh <parts-dir>"; exit 1; }
cd "$DIR"

shopt -s nullglob
sets=()
for f in *.zip.00.part; do
  sets+=("${f%.00.part}")
done
[ "${#sets[@]}" -eq 0 ] && { echo "koi .part file nahi mili"; exit 1; }

for z in "${sets[@]}"; do
  echo "--- $z"
  cat "$z".*.part > "$z.tmp"
  mv "$z.tmp" "$z"
  ls -lh "$z" | awk '{print "    "$5"  "$9}'
  if command -v unzip >/dev/null 2>&1; then
    unzip -tq "$z" >/dev/null 2>&1 && echo "    zip integrity: OK" || echo "    zip integrity: FAIL"
  fi
done

if [ -f SHA256SUMS.txt ]; then
  echo "=== sha256 check (parts) ==="
  sha256sum -c SHA256SUMS.txt --quiet && echo "sab parts match ✅"
fi
