set -e # this script will exit if any command returns a non-null value

PROFILE_URL="https://openwhyd.org/test"

DEST_DIR="./tmp"
mkdir -p "${DEST_DIR}"

docker build --tag "openwhyd-pl-dl" .

docker run -t --rm -v "${PWD}:/app" -w "/app" "openwhyd-pl-dl" \
           "/bin/bash" -c "./openwhyd-pl-dl-json.sh ${PROFILE_URL} ${DEST_DIR}"

[ ! -f "${DEST_DIR}/playlists.json" ] && echo "❌ Missing: ${DEST_DIR}/playlists.json" && exit 1

rm -rf "${DEST_DIR}"

echo "✅ Done."
