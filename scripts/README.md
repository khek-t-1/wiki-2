# Scripts — Gofile se data laa kar GitHub release mein daalna

Ye scripts wahan chalti hain jahan **internet khula ho** (Colab, VPS, ya apna laptop).
Arena sandbox se `gofile.io` aur `uploads.github.com` dono block hain, is liye download
aur asset upload yahan mumkin nahi.

## Requirements

```bash
pip install -q gallery-dl     # gofile downloader
# gh (GitHub CLI) + login:
gh auth login -h github.com -p https -w   # browser se device code
gh auth setup-git
```

Plus: `bash`, `curl`, `zip`, `split`, `python3` (Colab mein sab pehle se hote hain).

## Ek command (recommended)

```bash
git clone --depth 1 https://github.com/khek-t-1/wiki-2.git /content/wiki-2
bash /content/wiki-2/scripts/run_all.sh
```

Custom repo/tag:

```bash
REPO=<owner>/<repo> TAG=v1.0 PART_SIZE=24M bash /content/wiki-2/scripts/run_all.sh
```

## Steps alag alag (agar beech mein net toot jaye)

| Script | Kaam | Resume |
|---|---|---|
| `01_download_gofile.sh` | 10 gofile folders → `$DEST/raw/` | mojood folders skip |
| `02_pack_and_split.sh` | har folder ka `.zip` → 24 MB `.part` + `SHA256SUMS.txt`, `MANIFEST.csv` | mojood zips skip |
| `03_upload_release.sh` | release create + assets upload | release par mojood assets skip |
| `join_parts.sh <dir>` | parts → zip, `unzip -t` + sha256 verify | — |

```bash
DEST=/content/pnb_download bash scripts/01_download_gofile.sh
DEST=/content/pnb_download PART_SIZE=24M bash scripts/02_pack_and_split.sh
REPO=khek-t-1/wiki-2 TAG=v1.0 bash scripts/03_upload_release.sh
```

## Output structure

```
/content/pnb_download/
├── raw/                        # downloaded originals (10 folders)
├── zips/                       # ek folder = ek zip
│   └── 03_Glot500_pnb_Arab.zip
└── parts/                      # release assets
    ├── 03_Glot500_pnb_Arab.zip.00.part … .14.part
    ├── SHA256SUMS.txt
    ├── MANIFEST.csv
    └── JOIN.md
```

## Troubleshooting

| Masla | Hal |
|---|---|
| `step 1 fail` / 404 on a folder | Gofile links **10 din inactivity** par expire hote hain. Purana bundle 29 Oct ka hai — agar koi folder dead hai to `pnb_datasets/LICENSES_AND_SOURCES.md` ke direct URLs se wohi files dobara download karein (Wikimedia/HF open hain). |
| `push permission nahi` | `gh` account ke paas target repo ka write access nahi. Ya access dein, ya `REPO=<apna-account>/pnb-datasets` use karein (`gh repo create <apna-account>/pnb-datasets --public`). |
| upload beech mein ruk gaya | Wohi command dobara — uploaded assets skip ho jayenge. |
| `release asset limit` | Har asset max 2 GB, ek release mein max 1000 assets. 24 MB parts ke saath ~40 assets bante hain — bilkul theek. |
| Disk space | Download + zips + parts ≈ **2.4 GB**. Colab par `/content` kaafi hai. |
| 100 MB se bari file repo mein | Parts jaan bujh kar 24 MB hain (GitHub git limit 100 MB, release limit 2 GB). |

## Note

`01_download_gofile.sh` root code `NvnvtGwy` download **nahi** karta — uske andar wohi 10
folders dobara hain (778 MB duplicate). Documentation files repo ke `pnb_datasets/` mein hain.
