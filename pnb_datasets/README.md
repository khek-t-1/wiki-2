# Punjabi (Shahmukhi) — `pnb` / `pnb_Arab` Dataset Bundle

> **Source (Gofile, 10 din inactivity par expire): https://gofile.io/d/NvnvtGwy**
> Per-folder links: [`DOWNLOAD_LINKS.md`](DOWNLOAD_LINKS.md)
> GitHub release (24 MB parts): is repo ke **Releases** tab mein — `scripts/` se banti hai.

**Language:** Western Punjabi / Shahmukhi Punjabi (ISO `pnb`, script `Arab`)
**Collected:** 2026-10-29
**Format:** Raw / original files — koi cleaning, dedup ya conversion nahi kiya gaya.
**Total:** 27 data files, **778.6 MB** (742.5 MiB) + documentation.

> Note: `pnb` (Shahmukhi, Pakistan) aur `pa` (Gurmukhi, India) alag alag hain.
> Is bundle mein sirf **Shahmukhi/Arabic script** wala data hai.

---

## Folder structure aur contents

### `01_Wikipedia_pnb_XML_dump/` — 237.9 MB
Official Wikimedia dump, snapshot **2026-10-01** (`articlesdump: done`).

| File | Size | Contents |
|---|---|---|
| `pnbwiki-latest-pages-articles.xml.bz2` | 116.5 MB | Current revisions, raw wikitext. **129,987 pages** |
| `pnbwiki-latest-pages-articles-multistream.xml.bz2` | 119.8 MB | Same content, random-access friendly |
| `pnbwiki-latest-pages-articles-multistream-index.txt.bz2` | 1.0 MB | Multistream byte offsets |
| `pnbwiki-latest-all-titles-in-ns0.gz` | 0.6 MB | **93,643** article titles |
| `pnbwiki-latest-md5sums.txt` | 3 KB | Official checksums (verified ✅) |
| `pnbwiki-20261001-dumpstatus.json` | 1 KB | Dump job status |

Source: <https://dumps.wikimedia.org/pnbwiki/latest/>
License: CC BY-SA 4.0 / GFDL

Parsing tip: `mwxml` + `mwparserfromhell`, ya `wikiextractor`.
Multistream sirf tab lein jab random access chahiye — content identical hai.

### `02_Wikipedia_pnb_HF_parquet/` — 133.3 MB
`wikipedia_pnb_20231101.parquet` — HuggingFace `wikimedia/wikipedia`, config `20231101.pnb`.
**72,307 articles**, ~**165.8 million characters**. Already-clean plain text (markup removed).
Columns: `id`, `url`, `title`, `text`.

Source: <https://huggingface.co/datasets/wikimedia/wikipedia>
License: CC BY-SA 3.0 / GFDL

**Sab se aasan starting point** — `pd.read_parquet(...)` aur seedha `text` column.

### `03_Glot500_pnb_Arab/` — 345.5 MB ⭐ sab se bara
`pnb_Arab-train-00000-of-00001.arrow` — **897,929 rows**, ~**175.6 million characters**.
Columns: `text`, `dataset`, `script`, `lang_script`.

Source breakdown (`dataset` column):

| Source | Rows |
|---|---|
| Wikipedia | 433,615 |
| Leipzig_wikipedia | 368,913 |
| Leipzig_community | 44,522 |
| Oscar22 | 43,141 |
| wiki | 7,263 |
| mtdata | 473 |
| Tatoeba | 2 |

Source: <https://huggingface.co/datasets/cis-lmu/Glot500>
License: packaging/metadata CC0; underlying text ka license original source ke mutabiq.

**Important:** Is mein **Leipzig Wikipedia + Leipzig community + OSCAR-2201** ka pnb data
pehle se mojood hai — yani Leipzig aur OSCAR ka bara hissa aap ko yahin mil jata hai,
alag se download ki zaroorat nahi.

Load karne ka tareeqa:
```python
import pyarrow as pa
with pa.memory_map("pnb_Arab-train-00000-of-00001.arrow", "rb") as src:
    table = pa.ipc.open_stream(src).read_all()
df = table.to_pandas()
```

### `04_FineWeb2_pnb_Arab/` — 33.7 MB (OSCAR alternative #1)
`fineweb2_pnb_Arab_train.parquet` — **20,767 documents**, ~**58.3 million characters**.
CommonCrawl-derived, saaf web text. Columns: `text`, `id`, `dump`, `url`, `date`,
`file_path`, `language`, `language_score`, `language_script`, `minhash_cluster_size`, `top_langs`.

Top domains: `saraiki.app.com.pk` (3,720), `pnb.wikipedia.org` (3,675),
`pakistanpoint.com` (2,095), `wichaar.com` (1,884), `bhulekhatv.com` (1,251), `rvel.org` (1,249).

Source: <https://huggingface.co/datasets/HuggingFaceFW/fineweb-2> (`data/pnb_Arab`)
License: **ODC-BY** — no login, no gating.

### `05_GlotCC_V1_pnb_Arab/` — 18.3 MB (OSCAR alternative #2)
`GlotCC-V1_pnb-Arab_0.parquet` — **3,615 documents**, ~**21.7 million characters**.
CommonCrawl-derived with WARC provenance + quality warnings.
Columns include `content`, `warc-target-uri`, `warc-date`, `warc-record-id`,
`quality-warnings`, `identification-prob`, `script-percentage`, `num-sents`, `tlsh`.

Source: <https://huggingface.co/datasets/cis-lmu/GlotCC-V1>
License: **CC0-1.0** — no login.

Note: text column ka naam `content` hai, `text` nahi.

### `06_OSCAR_pnb_open_mirrors/` — 6.3 MB
Community-mirrored OSCAR pnb slices (ungated):
- `oscar_pnb_dev.parquet` — **1,000 documents** (~30.4 MB uncompressed text)
- `oscar_pnb_test.parquet` — **19 documents** (~0.33 MB uncompressed text)
- Original README files included.

Sources: `yiyic/oscar_pnb_dev`, `yiyic/oscar_pnb_test` on HuggingFace.

⚠️ Ye chhote held-out slices hain, poora OSCAR nahi. Bara OSCAR pnb data ke liye:
`03_Glot500` mein 43,141 Oscar22 rows already hain. Poora official OSCAR-2109 chahiye
to HF par terms accept karein — `download_oscar_2109.sh` script isi bundle mein hai.

### `07_Leipzig_LCC_pnb/` — 1.7 MB
`pnb_community_2017_urls.tsv` — **25,687 source URLs** (+ dates)
`pnb_community_2017_domains.tsv` — domain list

⚠️ **Leipzig ne is corpus ka text download band kar diya hai.** Portal saaf kehta hai
"No downloads available". Corpus stats: 1,052,347 tokens / 64,365 types / 63,683 sentences.
Sirf URL aur domain lists milti hain — wohi di gayi hain.

**Good news:** Leipzig community corpus ka text Glot500 mein `Leipzig_community`
(44,522 rows) aur `Leipzig_wikipedia` (368,913 rows) ke tor par mojood hai → folder 03.

Source: <https://curl.corpora.uni-leipzig.de/languages/pnb>
Terms: <https://wortschatz.uni-leipzig.de/en/usage>

### `08_OPUS_parallel_pnb/` — 1.1 MB (bonus)
Parallel (bilingual) corpora, Moses format `.txt.zip`:

| File | Pairs |
|---|---|
| `OPUS_translatewiki_en-pnb.txt.zip` | 10,014 |
| `OPUS_wikimedia_en-pnb.txt.zip` | 3,386 |
| `OPUS_QED_ab-pnb.txt.zip` | 467 |
| `OPUS_wikimedia_pa-pnb.txt.zip` | 66 (Gurmukhi↔Shahmukhi!) |
| `OPUS_Tatoeba_en-pnb.txt.zip` | 32 |

Source: <https://opus.nlpl.eu/> — license per corpus (mostly CC).
`pa-pnb` transliteration/script-conversion training ke liye mufeed hai.

### `09_pnb_Wiktionary/` — 0.8 MB (bonus)
`pnbwiktionary-latest-pages-articles.xml.bz2` (757 KB) + all-titles (38 KB).
Lexicon, word forms, definitions — spell-checker / tokenizer / vocab kaam ke liye.

Source: <https://dumps.wikimedia.org/pnbwiktionary/latest/>
License: CC BY-SA 4.0 / GFDL

### `10_Tatoeba_pnb/` — 1.5 KB
`pnb_sentences.tsv.bz2` — **77 sentences** (aap ne 72 kaha tha; ab 77 hain).
`pnb_links.tsv.bz2` — translation links.

Aap ki baat durust: monolingual training ke liye bekaar. Sirf completeness ke liye shaamil.
License: CC-BY 2.0 FR

---

## Verification

- Wikimedia dumps: official MD5 **verify ho gaye** ✅, `bzip2 -t` integrity pass ✅
- Tamam 27 files ke SHA-256 + MD5: `SHA256SUMS.txt` aur `MANIFEST.csv`
- Row counts actually files khol kar gine gaye hain, metadata se copy nahi kiye.

```bash
sha256sum -c SHA256SUMS.txt
```

## Overlap warning

In sources mein **kaafi duplication** hai — sab pnb Wikipedia se hi aate hain:

- 01, 02 = same Wikipedia (raw wikitext vs clean text, different dates)
- 03 Glot500 mein Wikipedia + Leipzig + OSCAR sab shamil
- 04 FineWeb-2 mein ~3,675 Wikipedia docs
- 05 GlotCC mein ~3,351 Wikipedia docs

Training se pehle **URL ya MinHash dedup** zaroor karein, aur dev/test set ko
train se alag rakhein — warna results inflated aayenge.

## Recommended usage

| Kaam | Kya use karein |
|---|---|
| LM pretraining (max data) | 03 Glot500 + 04 FineWeb-2 + 05 GlotCC, phir dedup |
| Jaldi shuru karna | 02 HF parquet (clean text, ready) |
| Web/register diversity | 04 FineWeb-2 (Saraiki news, forums, blogs) |
| Provenance chahiye | 05 GlotCC (WARC IDs + quality flags) |
| Fresh Wikipedia | 01 XML dump (Oct 2026) |
| Translation / transliteration | 08 OPUS |
| Vocab / spellcheck | 09 Wiktionary |

## Citation

Glot500:
```bibtex
@inproceedings{imanigooghari-etal-2023-glot500,
  title={Glot500: Scaling Multilingual Corpora and Language Models to 500 Languages},
  author={ImaniGooghari, Ayyoob and Lin, Peiqin and Kargaran, Amir Hossein and
 Severini, Silvia and Sabet, Masoud Jalili and Kassner, Nora and Ma, Chunlan and
 Schmid, Helmut and Martins, Andr{\'e} F. T. and Yvon, Fran{\c{c}}ois and
 Sch{\"u}tze, Hinrich},
  booktitle={Proceedings of ACL}, year={2023}
}
```
Baaki citations aur license details: `LICENSES_AND_SOURCES.md`.
