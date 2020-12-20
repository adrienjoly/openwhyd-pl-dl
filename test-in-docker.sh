set -e # this script will exit if any command returns a non-null value

DEST_DIR="./tmp"
docker build --tag "openwhyd-pl-dl" .

# 1. Test openwhyd-pl-dl-json.sh

PROFILE_URL="https://openwhyd.org/test"

mkdir -p "${DEST_DIR}"

docker run -t --rm -v "${PWD}:/app" -w "/app" "openwhyd-pl-dl" \
           "/bin/bash" -c "./openwhyd-pl-dl-json.sh ${PROFILE_URL} ${DEST_DIR}"

[ ! -f "${DEST_DIR}/playlists.json" ] && echo "❌ Missing: ${DEST_DIR}/playlists.json" && exit 1

rm -rf "${DEST_DIR}"

# 2. Test openwhyd-dl.sh

PLAYLIST_URL="https://openwhyd.org/test/playlist/2" # playlist with just 1 short mp3 file

mkdir -p "${DEST_DIR}"

docker run -t --rm -v "${PWD}:/app" -w "/app" "openwhyd-pl-dl" \
           "/bin/bash" -c "./openwhyd-dl.sh ${PLAYLIST_URL} ${DEST_DIR}"

[ ! -f "${DEST_DIR}/00001 - mpthreetest.mp3" ] && echo "❌ Missing: ${DEST_DIR}/00001 - mpthreetest.mp3" && exit 1

rm -rf "${DEST_DIR}"

echo "✅ Done."
