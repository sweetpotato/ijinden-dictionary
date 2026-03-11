#!/bin/bash
export LANG=C LC_ALL=C
set -Cxueo pipefail

bin="$(dirname "${BASH_SOURCE[0]}")"
cd "${bin}"

jq -c '.[]' ../ijinden-deck-builder/src/commons/cards.json |
  perl append-rule-text.pl

find ../public -mindepth 1 -maxdepth 1 -name '*.html' -print0 |
  xargs -r -0 -n 1 -- perl -i append-site-name.pl

find ../public -mindepth 1 -maxdepth 1 -name '*.html' -print0 |
  xargs -r -0 -n 1 -- perl -i append-copyright.pl

perl -i replace-index-title.pl ../public/index.html
