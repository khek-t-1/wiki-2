# Licenses, Sources aur Attribution

Ye bundle sirf publicly available data ka redistribution hai. Har file ka original
license laagu hota hai. Commercial use se pehle original terms khud parhein.

## Per-folder license summary

| Folder | Source | License | Login required? |
|---|---|---|---|
| 01 Wikipedia XML | dumps.wikimedia.org/pnbwiki | CC BY-SA 4.0 + GFDL | No |
| 02 Wikipedia HF | wikimedia/wikipedia | CC BY-SA 3.0 + GFDL | No |
| 03 Glot500 | cis-lmu/Glot500 | Packaging CC0; text = original source license | No |
| 04 FineWeb-2 | HuggingFaceFW/fineweb-2 | ODC-BY 1.0 | No |
| 05 GlotCC-V1 | cis-lmu/GlotCC-V1 | CC0-1.0 | No |
| 06 OSCAR mirrors | yiyic/oscar_pnb_{dev,test} | OSCAR terms (CC0 metadata; text per source) | No |
| 07 Leipzig URLs | curl.corpora.uni-leipzig.de | Leipzig LCC terms of usage | No |
| 08 OPUS | opus.nlpl.eu | Per-corpus (mostly CC / open) | No |
| 09 pnb Wiktionary | dumps.wikimedia.org/pnbwiktionary | CC BY-SA 4.0 + GFDL | No |
| 10 Tatoeba | tatoeba.org | CC-BY 2.0 FR | No |

## Exact source URLs (re-download ke liye)

```
# 01
https://dumps.wikimedia.org/pnbwiki/latest/pnbwiki-latest-pages-articles.xml.bz2
https://dumps.wikimedia.org/pnbwiki/latest/pnbwiki-latest-pages-articles-multistream.xml.bz2
https://dumps.wikimedia.org/pnbwiki/latest/pnbwiki-latest-pages-articles-multistream-index.txt.bz2
https://dumps.wikimedia.org/pnbwiki/latest/pnbwiki-latest-all-titles-in-ns0.gz
https://dumps.wikimedia.org/pnbwiki/latest/pnbwiki-latest-md5sums.txt
https://dumps.wikimedia.org/pnbwiki/20261001/dumpstatus.json

# 02
https://huggingface.co/datasets/wikimedia/wikipedia/resolve/main/20231101.pnb/train-00000-of-00001.parquet

# 03
https://huggingface.co/datasets/cis-lmu/Glot500/resolve/main/pnb_Arab/train/data-00000-of-00001.arrow
https://huggingface.co/datasets/cis-lmu/Glot500/resolve/main/pnb_Arab/train/dataset_info.json
https://huggingface.co/datasets/cis-lmu/Glot500/resolve/main/pnb_Arab/train/state.json

# 04
https://huggingface.co/datasets/HuggingFaceFW/fineweb-2/resolve/main/data/pnb_Arab/train/000_00000.parquet

# 05
https://huggingface.co/datasets/cis-lmu/GlotCC-V1/resolve/main/v1.0/pnb-Arab/pnb-Arab_0.parquet

# 06
https://huggingface.co/datasets/yiyic/oscar_pnb_dev/resolve/main/data/train-00000-of-00001.parquet
https://huggingface.co/datasets/yiyic/oscar_pnb_test/resolve/main/data/train-00000-of-00001.parquet

# 07
https://curl.corpora.uni-leipzig.de/languages/pnb/urls?download
https://curl.corpora.uni-leipzig.de/languages/pnb/urls?only_domains&download

# 08
https://object.pouta.csc.fi/OPUS-translatewiki/v2026-07-01/moses/en-pnb.txt.zip
https://object.pouta.csc.fi/OPUS-wikimedia/v20260327/moses/en-pnb.txt.zip
https://object.pouta.csc.fi/OPUS-wikimedia/v20260327/moses/pa-pnb.txt.zip
https://object.pouta.csc.fi/OPUS-Tatoeba/v2026-07-08/moses/en-pnb.txt.zip
https://object.pouta.csc.fi/OPUS-QED/v2.0a/moses/ab-pnb.txt.zip

# 09
https://dumps.wikimedia.org/pnbwiktionary/latest/pnbwiktionary-latest-pages-articles.xml.bz2
https://dumps.wikimedia.org/pnbwiktionary/latest/pnbwiktionary-latest-all-titles-in-ns0.gz

# 10
https://downloads.tatoeba.org/exports/per_language/pnb/pnb_sentences.tsv.bz2
https://downloads.tatoeba.org/exports/per_language/pnb/pnb_links.tsv.bz2
```

## Glot500 ka license note (verbatim)

> "We don't own any part of the data. The original source of each sentence of the data
> is indicated in dataset field. To see the copyright license of the original datasets
> visit https://github.com/cisnlp/Glot500#glot500-c
> We license the actual packaging, the metadata and the annotations of these data
> under the cc0-1.0."

Yani Glot500 use karte waqt `dataset` column dekh kar original source ka license
follow karna aap ki zimmedari hai.

## FineWeb-2 / GlotCC — CommonCrawl caveat

Ye dono CommonCrawl se derive hue hain. Corpus license (ODC-BY / CC0) **underlying
web pages ke copyright ko override nahi karta**. Content ke original rights web
publishers ke paas hain. Apne use case ke liye legal review karein.

## OSCAR-2109 (gated — is bundle mein shaamil NAHI)

Official `oscar-corpus/OSCAR-2109` gated (`manual`) hai. Aap ki request par open
alternatives (FineWeb-2, GlotCC-V1) shaamil kiye gaye.

pnb file sizes (agar aap khud access lein):

| Path | Size |
|---|---|
| `packaged/pnb/pnb.txt.gz` (deduplicated) | 12.29 MB |
| `packaged/pnb/pnb_meta.jsonl.gz` | 1.20 MB |
| `packaged_nondedup/pnb/pnb.txt.gz` | 16.72 MB |
| `packaged_nondedup/pnb/pnb_meta.jsonl.gz` | 3.25 MB |

Steps:
1. <https://huggingface.co/datasets/oscar-corpus/OSCAR-2109> par login karein
2. Terms/access form fill karein, approval ka intezar karein
3. <https://huggingface.co/settings/tokens> se **read** token banayein
4. `bash download_oscar_2109.sh` chalayein (token poochega)

OSCAR citation:
```bibtex
@inproceedings{abadji-etal-2022-cleaner,
  title={A Cleaner Version of the {OSCAR} Corpus},
  author={Abadji, Julien and Ortiz Su{\'a}rez, Pedro Javier and
 Romary, Laurent and Sagot, Beno{\^i}t},
  booktitle={Proceedings of WILDRE}, year={2022}
}
```

## Baaki citations

FineWeb-2:
```bibtex
@misc{penedo2024fineweb2,
  title={FineWeb-2: A sparkling update with 1000+ languages},
  author={Penedo, Guilherme and Kydl{\'i}{\v{c}}ek, Hynek and Cappelli, Alessandro and
 Sasko, Mario and Wolf, Thomas},
  year={2024}, publisher={Hugging Face}
}
```

GlotCC:
```bibtex
@inproceedings{kargaran-etal-2024-glotcc,
  title={GlotCC: An Open Broad-Coverage CommonCrawl Corpus and Pipeline for Minority Languages},
  author={Kargaran, Amir Hossein and Yvon, Fran{\c{c}}ois and Sch{\"u}tze, Hinrich},
  year={2024}
}
```

Leipzig / LCC:
```bibtex
@inproceedings{goldhahn-etal-2012-building,
  title={Building Large Monolingual Dictionaries at the {L}eipzig {C}orpora {C}ollection},
  author={Goldhahn, Dirk and Eckart, Thomas and Quasthoff, Uwe},
  booktitle={Proceedings of LREC}, year={2012}
}
```

OPUS:
```bibtex
@inproceedings{tiedemann-2012-parallel,
  title={Parallel Data, Tools and Interfaces in {OPUS}},
  author={Tiedemann, J{\"o}rg},
  booktitle={Proceedings of LREC}, year={2012}
}
```

## Sources jo check kiye magar pnb data nahi mila

| Source | Nateeja |
|---|---|
| CC-100 | `pnb.txt.xz` → HTTP 404. Sirf `pa` (Gurmukhi) aur `ur` available |
| MADLAD-400 | Sirf `data/pa` — koi `pnb` nahi |
| HPLT 2.0 cleaned | `pan_Guru`, `urd_Arab` hain; `pnb_Arab` nahi |
| CulturaX | pnb tag hai magar gated (`auto`) — login chahiye |
| Leipzig corpus text | Portal: "No downloads available" |
