# wiki-2 — Punjabi (Shahmukhi) `pnb` dataset bundle

Western Punjabi / Shahmukhi (ISO **`pnb`**, script **`Arab`**) ka raw text corpus —
Wikipedia dumps, HuggingFace corpora, web text, parallel data aur lexicon.
Total **778.6 MB**, 27 original files.

> `pnb` (Shahmukhi, Pakistan) aur `pa` (Gurmukhi, India) alag languages hain.
> Is bundle mein sirf Arabic-script wala data hai.

## Data kahan se lein

| Zariya | Link | Note |
|---|---|---|
| **Gofile** (original upload) | <https://gofile.io/d/NvnvtGwy> | Public, login nahi. **10 din inactivity** par expire |
| **GitHub Release** (24 MB parts) | repo ke **Releases** tab mein | Parts join karne ka tareeqa neeche |

Gofile per-folder links aur tafseel: [`pnb_datasets/DOWNLOAD_LINKS.md`](pnb_datasets/DOWNLOAD_LINKS.md)

## Bundle mein kya hai

| # | Folder | Size | Contents |
|---|---|---|---|
| 01 | Wikipedia XML dump | 237.9 MB | 129,987 pages (snapshot 2026-10-01) |
| 02 | Wikipedia HF parquet | 133.3 MB | 72,307 clean articles (~165.8M chars) |
| 03 | **Glot500 `pnb_Arab`** ⭐ | 345.5 MB | **897,929 rows** (Wiki 433k + Leipzig 413k + OSCAR 43k) |
| 04 | FineWeb-2 `pnb_Arab` | 33.7 MB | 20,767 web docs (ODC-BY) |
| 05 | GlotCC-V1 `pnb-Arab` | 18.3 MB | 3,615 docs (CC0) |
| 06 | OSCAR open mirrors | 6.3 MB | 1,019 docs (`yiyic/oscar_pnb_dev` + `_test`) |
| 07 | Leipzig LCC pnb | 1.7 MB | 25,687 source URLs (text download band) |
| 08 | OPUS parallel | 1.1 MB | 13,965 sentence pairs |
| 09 | pnb Wiktionary | 0.8 MB | lexicon |
| 10 | Tatoeba pnb | 1.5 KB | 77 sentences |

Poori tafseel (row counts, loading code, overlap warnings): [`pnb_datasets/README.md`](pnb_datasets/README.md)
Licenses + original source URLs: [`pnb_datasets/LICENSES_AND_SOURCES.md`](pnb_datasets/LICENSES_AND_SOURCES.md)

## Parts join karna (release download ke baad)

Har zip 24 MB parts mein hai (`NAME.zip.00.part`, `.01.part`, …):

```bash
for f in *.zip.00.part; do z="${f%.00.part}"; cat "$z".*.part > "$z"; done
sha256sum -c SHA256SUMS.txt
unzip 03_Glot500_pnb_Arab.zip
```

Script se: `bash scripts/join_parts.sh <parts-dir>`

## Ye repo khud data laa kar release banana chahta hai?

`scripts/` mein mukammal pipeline hai (jahan internet khula ho, jaise Colab):

```bash
git clone --depth 1 https://github.com/khek-t-1/wiki-2.git /content/wiki-2
bash /content/wiki-2/scripts/run_all.sh      # download → split → release upload
```

Tafseel: [`scripts/README.md`](scripts/README.md)

> **Note:** Arena sandbox se `gofile.io` aur `uploads.github.com` blocked hain, is liye
> 778 MB data yahan download/upload nahi ho saka — isi liye pipeline scripts ki soorat mein hai.

## Structure

```
pnb_datasets/          # bundle ki documentation (previous collection se)
  README.md            #   row counts, load code, caveats
  DOWNLOAD_LINKS.md    #   gofile per-folder links + expiry warning
  LICENSES_AND_SOURCES.md
  download_oscar_2109.sh
scripts/               # download → zip/split → GitHub release pipeline
  01_download_gofile.sh
  02_pack_and_split.sh
  03_upload_release.sh
  join_parts.sh
  run_all.sh
```

## Licenses

Mixed: CC BY-SA (Wikipedia), ODC-BY (FineWeb-2), CC0 (GlotCC-V1 packaging), aur
Glot500/OSCAR/OPUS ke apne terms. Har folder ka license `pnb_datasets/LICENSES_AND_SOURCES.md` mein.
