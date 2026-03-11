#!/bin/bash
export LANG=C LC_ALL=C
set -Cxueo pipefail

bin="$(dirname "${BASH_SOURCE[0]}")"
cd "${bin}"

jq -r '.[]|[.id,.name]|@tsv' ../ijinden-deck-builder/src/commons/cards.json |
  sed -r -e 's/^(.*?)\t(.*?)$/|\1|[[\2]]|/g'
