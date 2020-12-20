#!/bin/bash

# This script downloads playlists of an OpenWhyd profile in JSON format.
# syntax: ./openwhyd-pl-dl-json.sh https://openwhyd.org/adrien

PROFILE_URL=$1
DEST_PATH="./$2"

echo "Fetching JSON playlists from $PROFILE_URL/playlists ..."

curl -sS "$PROFILE_URL/playlists?format=json" | jq . > "${DEST_PATH}/playlists.json"

jq -c '.[]' "${DEST_PATH}/playlists.json" \
  | while read PL ; do
    PL_URL=$(echo $PL | jq -r '.url') # extract playlist URL
    PL_NAME=$(echo $PL | jq -r '.name') # extract playlist name
    PL_NUM=$(echo $PL | jq -r '.id') # extract playlist number
    PL_NUM_PADDED=$(printf "%03d\n" $PL_NUM) # 0-padding
    PL_NAME=$(echo $PL_NAME | tr -dc '[:alnum:]\n\r') # remove special characters
    PL_FILENAME="${DEST_PATH}/$PL_NUM_PADDED-$PL_NAME.json"
    echo "- $PL_URL => $PL_FILENAME"
    # echo "mkdir \"$PL_PATH\"; cd \"$PL_PATH\"; ../openwhyd-dl.sh \"https://openwhyd.org$PL_URL\"; cd .." >>$DOWNLOAD_SCRIPT
    curl -sS "${PROFILE_URL}/playlist/${PL_NUM}?format=json&limit=999999" | jq . > "${PL_FILENAME}"
done;
