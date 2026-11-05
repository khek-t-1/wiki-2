# Gofile Download Links — Punjabi Shahmukhi (pnb) Datasets

## 🎯 Main link (sab kuch ek jagah)

# **https://gofile.io/d/NvnvtGwy**

Total: **778.6 MB**, 27 data files + 5 documentation files, 10 folders.
Public hai — login ki zaroorat nahi.

---

## ⚠️ Zaroori: 10-din ki deadline

Gofile free/guest storage **ephemeral** hai: **10 din inactivity** ke baad content
delete (ya cold storage mein move) ho jata hai. Jitna download hota rahega, utna
zyada arsa chalega.

**Isliye: jaldi download kar lein.** Long-term chahiye to apne Google Drive /
HuggingFace repo / local disk par transfer kar lein.

---

## Per-folder direct links

| # | Folder | Size | Link |
|---|---|---|---|
| 01 | Wikipedia pnb XML dump | 237.9 MB | https://gofile.io/d/L7CwvZeR |
| 02 | Wikipedia pnb HF parquet | 133.3 MB | https://gofile.io/d/B2ROR22U |
| 03 | **Glot500 pnb_Arab** ⭐ | 345.5 MB | https://gofile.io/d/QF74JedQ |
| 04 | FineWeb-2 pnb_Arab | 33.7 MB | https://gofile.io/d/9o75K4s3 |
| 05 | GlotCC-V1 pnb-Arab | 18.3 MB | https://gofile.io/d/BGFD7emj |
| 06 | OSCAR pnb open mirrors | 6.3 MB | https://gofile.io/d/OAzZqJdF |
| 07 | Leipzig LCC pnb (URLs) | 1.7 MB | https://gofile.io/d/ESjUNlHP |
| 08 | OPUS parallel pnb | 1.1 MB | https://gofile.io/d/gQZSE92X |
| 09 | pnb Wiktionary | 0.8 MB | https://gofile.io/d/FGq36ER0 |
| 10 | Tatoeba pnb | 1.5 KB | https://gofile.io/d/vXUnoA5G |

Documentation (README, licenses, checksums, OSCAR script) main folder
`NvnvtGwy` ki root mein hai.

---

## Sirf 3 files chahiye to (sab se kaam ki)

Agar poora 778 MB nahi chahiye, ye 3 kaafi hain:

1. **Glot500** — https://gofile.io/d/QF74JedQ
   `pnb_Arab-train-00000-of-00001.arrow` (345 MB, 897,929 rows)
   Ismein Wikipedia + Leipzig + OSCAR sab shamil hai.
2. **FineWeb-2** — https://gofile.io/d/9o75K4s3
   `fineweb2_pnb_Arab_train.parquet` (34 MB, 20,767 web docs)
3. **HF Wikipedia** — https://gofile.io/d/B2ROR22U
   `wikipedia_pnb_20231101.parquet` (133 MB, 72,307 clean articles)

Total ~512 MB, aur teenon `pandas.read_parquet` / `pyarrow` se seedha khul jate hain.

---

## Download kaise karein

**Browser se:** link kholein → file ke saamne "Download" button.

**Folder ZIP:** Gofile par "Download folder as ZIP" premium feature hai. Free mein
files ek ek kar ke download karein (ya subfolder links use karein).

**Command line se:** Gofile ka direct-download API premium hai. Free tier ke liye
browser sab se aasan hai. Agar aap ke paas original sources tak rasai hai to
`LICENSES_AND_SOURCES.md` mein tamam direct URLs diye hain — `wget`/`curl` se
seedha download kar sakte hain (HuggingFace aur Wikimedia par koi gating nahi,
sivaye official OSCAR-2109 ke).

---

## Verify karna

Download ke baad:
```bash
sha256sum -c SHA256SUMS.txt
```

Main link se `SHA256SUMS.txt` aur `MANIFEST.csv` (MD5 + SHA-256, har file ka) mil jayega.

**Tested:** guest browser session se download kar ke byte-level match confirm
kiya gaya — chhoti file ka MD5 exact match, aur 345 MB arrow file ke pehle 8 MB
local original se byte-for-byte identical (HTTP 206 range request). Wikimedia
dumps ke official MD5 bhi verify hue.
