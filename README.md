# DC Coming soon

An app to answer the question "*what's going to be coming near me soon?*".

## What it looks at

* [ABRA Notices of Public Hearing](http://abra.dc.gov/page/notices-public-hearing)
* [Zoning Commission and Board of Zoning Adjustment Cases](https://app.dcoz.dc.gov/content/search/Search.aspx)*

## Requirements

1. JRuby
2. [Poppler](http://poppler.freedesktop.org/)

## Running locally

1. `script/bootstrap`
2. `script/server`

## Huh? Why are you using JRuby?

Because [Tabular Extractor](https://github.com/tabulapdf/tabula-extractor) requires it.

## Huh? Why are you using [pdftotext](https://github.com/benbalter/pdftotext) and not something like [PDF Reader](https://github.com/yob/pdf-reader)?

PDF Reader doesn't properly handle superscript text, which ABRA often uses in street names (the text bleeds into the line above it).
