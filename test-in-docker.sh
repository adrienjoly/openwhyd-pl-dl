#!/bin/bash

set -e # this script will exit if any command returns a non-null value

DEST_DIR="./tmp"
docker build --tag "openwhyd-pl-dl" .

function run_in_container {
  docker run -t --rm -v "${PWD}:/app" -w "/app" "openwhyd-pl-dl" "/bin/bash" -c "$1"
}

function test {
  CMD="$1"
  EXPECTED_FILE="$2"
  # run test
  mkdir -p "${DEST_DIR}"
  run_in_container "${CMD}"
  # check expectation
  [ ! -f "${EXPECTED_FILE}" ] && echo "❌ Missing: ${EXPECTED_FILE}" && exit 1
  # cleanup
  rm -rf "${DEST_DIR}"
}

# 1. Test openwhyd-pl-dl-json.sh

PROFILE_URL="https://openwhyd.org/test"
test "./openwhyd-pl-dl-json.sh ${PROFILE_URL} ${DEST_DIR}" "${DEST_DIR}/playlists.json"

# 2. Test openwhyd-dl.sh

PLAYLIST_URL="https://openwhyd.org/test/playlist/2" # playlist with just 1 short mp3 file
EXPECTED_FILE="${DEST_DIR}/00001 - mpthreetest.mp3"
test "./openwhyd-dl.sh ${PLAYLIST_URL} ${DEST_DIR}" "${EXPECTED_FILE}"

echo "✅ Done."
