#!/usr/bin/env bash
#
# Step 3 — GitHub release banao aur saare parts upload karo (resume ke saath).
#
#   REPO=khek-t-1/wiki-2 TAG=v1.0 bash scripts/03_upload_release.sh
#
# - Pehle se upload shuda assets skip hote hain, is liye net toot jaye to
#   wohi command dobara chala do — wahin se aage barhega.
# - Preflight check: repo par aap ke gh account ke paas push permission hai ya nahi.
#
set -uo pipefail

REPO="${REPO:-khek-t-1/wiki-2}"
TAG="${TAG:-v1.0}"
DEST="${DEST:-/content/pnb_download}"
PARTS="$DEST/parts"
TITLE="${TITLE:-Punjabi Shahmukhi (pnb) dataset bundle — 778.6 MB}"
RETRIES="${RETRIES:-5}"

[ -d "$PARTS" ] || { echo "ERROR: $PARTS nahi mila — pehle step 02 chalao"; exit 1; }

# ---------- preflight ----------
echo "=== preflight ==="
gh auth status 2>&1 | sed -n '1,4p'
acct=$(gh api user -q .login 2>/dev/null || true)
echo "gh account: ${acct:-?}  |  target repo: $REPO"
push=$(gh api "repos/$REPO" -q .permissions.push 2>/dev/null || echo "no-access")
if [ "$push" != "true" ]; then
  cat <<EOF

ERROR: '$REPO' par '${acct:-aap ke account}' ke paas push permission nahi (ya repo nahi mila).

Do mein se ek karein:
  1) Isi account se repo ka access dein, ya
  2) Apne account par release banayein:
       REPO=${acct:-gifick-y}/pnb-datasets TAG=$TAG bash scripts/03_upload_release.sh
     (repo pehle banana ho to: gh repo create ${acct:-gifick-y}/pnb-datasets --public)

EOF
  exit 1
fi
echo "push permission: OK"

# ---------- release create (idempotent) ----------
cat > "$PARTS/JOIN.md" <<'EOF'
# How to join the parts

Har zip 24 MB ke parts mein toota hua hai (`.00.part`, `.01.part`, ...).
Join karne ke liye (Linux / macOS / WSL / Colab):

```bash
# sirf ek zip ke liye
cat 03_Glot500_pnb_Arab.zip.*.part > 03_Glot500_pnb_Arab.zip

# sab ke liye
for f in *.zip.00.part; do z="${f%.00.part}"; cat "$z".*.part > "$z"; done

# verify + unzip
sha256sum -c SHA256SUMS.txt    # parts ke checksums
unzip -t 03_Glot500_pnb_Arab.zip
unzip 03_Glot500_pnb_Arab.zip
```

Windows: `copy /b file.zip.00.part+file.zip.01.part+... file.zip`
ya 7-Zip mein pehla part khol kar extract karein.
EOF

notes=$(cat <<EOF
Punjabi (Shahmukhi) \`pnb\` dataset bundle — **778.6 MB**, 27 original files in 10 folders.

Collected from Wikimedia dumps, HuggingFace (\`wikimedia/wikipedia\`, Glot500, FineWeb-2,
GlotCC-V1), OPUS, Wiktionary aur Tatoeba. Raw files — koi cleaning/dedup nahi.
Tafseel: repo ka \`pnb_datasets/README.md\`, licenses: \`pnb_datasets/LICENSES_AND_SOURCES.md\`.

**Join:** \`cat NAME.zip.*.part > NAME.zip\` (dekhein \`JOIN.md\`)
**Verify:** \`sha256sum -c SHA256SUMS.txt\`

| Folder | Size | Contents |
|---|---|---|
| 01 Wikipedia XML dump | 237.9 MB | 129,987 pages |
| 02 Wikipedia HF parquet | 133.3 MB | 72,307 articles |
| 03 Glot500 pnb_Arab | 345.5 MB | 897,929 rows |
| 04 FineWeb-2 pnb_Arab | 33.7 MB | 20,767 web docs (ODC-BY) |
| 05 GlotCC-V1 pnb-Arab | 18.3 MB | 3,615 docs (CC0) |
| 06 OSCAR open mirrors | 6.3 MB | 1,019 docs |
| 07 Leipzig LCC pnb | 1.7 MB | 25,687 URLs |
| 08 OPUS parallel | 1.1 MB | 13,965 pairs |
| 09 pnb Wiktionary | 0.8 MB | lexicon |
| 10 Tatoeba pnb | 1.5 KB | 77 sentences |
EOF
)

if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "=== release $TAG pehle se mojood hai — assets resume honge ==="
else
  echo "=== release $TAG bana raha hoon ==="
  gh release create "$TAG" --repo "$REPO" --title "$TITLE" --notes "$notes" || {
    echo "release create fail"; exit 1; }
fi

# ---------- upload ----------
tmp_done=$(mktemp)
gh release view "$TAG" --repo "$REPO" --json assets -q '.assets[].name' > "$tmp_done" 2>/dev/null || true

total=0; up=0; skip=0; failed=0
shopt -s nullglob
files=("$PARTS"/*.part "$PARTS/SHA256SUMS.txt" "$PARTS/MANIFEST.csv" "$PARTS/JOIN.md")
total=${#files[@]}
echo "=== uploading $total assets (pehle se $(wc -l < "$tmp_done") mojood) ==="

for f in "${files[@]}"; do
  name=$(basename "$f")
  if grep -qxF "$name" "$tmp_done"; then
    skip=$((skip+1)); continue
  fi
  n=0; ok=0
  while [ "$n" -lt "$RETRIES" ]; do
    n=$((n+1))
    # output ko variable mein lete hain, warna pipe ka exit code (tail) 0 ho jata hai
    if out=$(gh release upload "$TAG" "$f" --repo "$REPO" 2>&1); then
      ok=1; break
    fi
    echo "$out" | tail -2 | sed 's/^/    /'
    echo "  retry $name ($n/$RETRIES) — 5s"
    sleep 5
  done
  if [ "$ok" -eq 1 ]; then
    up=$((up+1)); echo "  [$up/$total] $name"
  else
    failed=$((failed+1)); echo "  FAILED: $name"
  fi
done

echo
echo "=== done: uploaded=$up skipped=$skip failed=$failed ==="
echo "release: https://github.com/$REPO/releases/tag/$TAG"
gh release view "$TAG" --repo "$REPO" --json assets -q '.assets | length' | xargs echo "assets on release:"
[ "$failed" -gt 0 ] && { echo "Kuch fail hue — wohi command dobara chalao, baaki skip ho jayenge."; exit 1; }
exit 0
