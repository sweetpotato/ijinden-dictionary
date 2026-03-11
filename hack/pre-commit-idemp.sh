#!/bin/bash
export LANG=C LC_ALL=C
set -Cxueo pipefail

bin="$(dirname "${BASH_SOURCE[0]}")"
cd "${bin}"

find ../public -mindepth 1 -maxdepth 1 -name '__*__.html' -print0 |
  xargs -r -0 -- rm

find ../public -mindepth 1 -maxdepth 1 -name '*.html' -print0 |
  xargs -r -0 -n 1 -- perl -i remove-script.pl

find ../public -mindepth 1 -maxdepth 1 -name '*.html' -print0 |
  xargs -r -0 -- sed -i -r -e '/^\s*$/d' -e 's/^\s+|\s+$//g'
