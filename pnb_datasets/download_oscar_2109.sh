#!/usr/bin/env bash
# Official OSCAR-2109 pnb files download karein (aap ke apne HF access se).
#
# Pehle:
#   1. https://huggingface.co/datasets/oscar-corpus/OSCAR-2109 par login + terms accept
#   2. Approval ka intezar karein (gated: manual)
#   3. https://huggingface.co/settings/tokens se READ token banayein
#
# Usage:
#   bash download_oscar_2109.sh                 # token interactively poochega
#   HF_TOKEN=hf_xxx bash download_oscar_2109.sh # ya env var
set -euo pipefail

OUT="${1:-./oscar2109_pnb}"
mkdir -p "$OUT"

if [ -z "${HF_TOKEN:-}" ]; then
  read -r -s -p "HuggingFace read token: " HF_TOKEN; echo
fi
[ -n "$HF_TOKEN" ] || { echo "Token khali hai. Exit."; exit 1; }

BASE="https://huggingface.co/datasets/oscar-corpus/OSCAR-2109/resolve/main"

get () {
  local rel="$1" name="$2"
  echo "==> $rel"
  code=$(curl -sSL --retry 3 -w '%{http_code}' \
    -H "Authorization: Bearer $HF_TOKEN" \
    -o "$OUT/$name" "$BASE/$rel")
  if [ "$code" = "200" ]; then
    echo "    OK $(stat -c%s "$OUT/$name" 2>/dev/null || stat -f%z "$OUT/$name") bytes -> $OUT/$name"
  else
    echo "    FAIL HTTP $code"
    head -c 250 "$OUT/$name"; echo
    rm -f "$OUT/$name"
    return 1
  fi
}

# Deduplicated (recommended)
mkdir -p "$OUT/packaged"
get "packaged/pnb/pnb.txt.gz"          "packaged/pnb.txt.gz"          || true
get "packaged/pnb/pnb_meta.jsonl.gz"   "packaged/pnb_meta.jsonl.gz"   || true
get "packaged/pnb/pnb_sha256.txt"      "packaged/pnb_sha256.txt"      || true

# Non-deduplicated (bara)
mkdir -p "$OUT/packaged_nondedup"
get "packaged_nondedup/pnb/pnb.txt.gz"        "packaged_nondedup/pnb.txt.gz"        || true
get "packaged_nondedup/pnb/pnb_meta.jsonl.gz" "packaged_nondedup/pnb_meta.jsonl.gz" || true
get "packaged_nondedup/pnb/pnb_sha256.txt"    "packaged_nondedup/pnb_sha256.txt"    || true

echo
echo "Ho gaya: $OUT"
echo "Verify:  cd $OUT/packaged && sha256sum -c pnb_sha256.txt"
echo
echo "Yaad rakhein: OSCAR pnb ka bara hissa Glot500 (folder 03) mein"
echo "43,141 Oscar22 rows ke tor par pehle se mojood hai."
