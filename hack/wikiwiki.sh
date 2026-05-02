#!/bin/bash
export LANG=C LC_ALL=C
set -Cxueo pipefail

ENDPOINT=https://api.wikiwiki.jp/ijinden

declare bin
bin="$(dirname "${BASH_SOURCE[0]}")"

declare tmpdir

on_exit() {
  if [ -d "${tmpdir:-}" ] ; then
    rm -rf "${tmpdir}"
  fi
}

setup_tmpdir() {
  tmpdir="$(command mktemp -d)"
}

mktemp() {
  command mktemp -p "${tmpdir}" "$@"
}

curl() {
  command curl --fail-with-body -s -S "$@"
}

curl_json() {
  curl -H 'Content-Type: application/json' "$@"
}

curl_auth() {
  curl_json -X POST "$@"
}

curl_get() {
  curl -H @token.header.local "$@"
}

curl_update() {
  curl_json -X PUT -H @token.header.local "$@"
}

wikiwiki_auth() {
  # DO NOT dump secret
  set +x
  . apikey.rc.local
  set -x
  export API_KEY_ID
  export API_KEY_SECRET

  local response
  response="$(mktemp)"
  # The auth API returns 200 even on error
  envsubst <data_auth.json | curl_auth -d @- "${ENDPOINT}/auth" >|"${response}"
  # Look into the response body to check if the request succeeded
  jq -e '.status=="ok"' "${response}" >&2
  # Extract token from the response body
  jq -r '"Authorization: Bearer "+.token' "${response}" >|token.header.local
}

wikiwiki_list_pages() {
  curl_get "${ENDPOINT}/pages"
}

wikiwiki_get_page() {
  local page
  page="$1"

  curl_get "${ENDPOINT}/page/${page}"
}

wikiwiki_update_page() {
  local page
  page="$1"

  curl_update "${ENDPOINT}/page/${page}"
}

main() {
  cd "${bin}"

  trap on_exit EXIT
  setup_tmpdir

  local subcommand
  subcommand="$1"
  shift 1

  case "${subcommand}" in
  auth)
    wikiwiki_auth "$@"
    ;;
  list)
    wikiwiki_list_pages "$@"
    ;;
  get)
    wikiwiki_get_page "$@"
    ;;
  update)
    wikiwiki_update_page "$@"
    ;;
  esac
}

main "$@"
exit 0
