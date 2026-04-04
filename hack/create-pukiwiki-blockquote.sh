#!/bin/bash
export LANG=C LC_ALL=C
set -Cxueo pipefail

bin="$(dirname "${BASH_SOURCE[0]}")"
cd "${bin}"

jq -c '.[]' ../ijinden-deck-builder/src/commons/cards.json |
  perl create-pukiwiki-blockquote.pl
