# This script downloads playlists of an OpenWhyd profile in JSON format.
# syntax: ./openwhyd-pl-dl-json.sh https://openwhyd.org/adrien

PROFILE_URL=$1

echo "Fetching JSON playlists from $PROFILE_URL/playlists ..."
curl -sS "$PROFILE_URL/playlists?format=list" \
  | sed -n 's/.*\"\(\/u\/[^/]*\/playlist\/[0-9]*\)\"[^>]*\>\([^<]*\).*/\1,\2/p' \
  | while read PL ; do
    PL_URL=${PL%%,*} # extract playlist URL
    PL_NAME=${PL#*,} # extract playlist name
    PL_NUM=${PL_URL##*/} # extract playlist number
    PL_NUM=$(printf "%03d\n" $PL_NUM) # 0-padding
    PL_NAME=$(echo $PL_NAME | tr -dc '[:alnum:]\n\r') # remove special characters
    PL_FILENAME="$PL_NUM-$PL_NAME"
    echo "- $PL_URL => $PL_FILENAME"
    # echo "mkdir \"$PL_PATH\"; cd \"$PL_PATH\"; ../openwhyd-dl.sh \"https://openwhyd.org$PL_URL\"; cd .." >>$DOWNLOAD_SCRIPT
    curl -sS "$PROFILE_URL?format=json&limit=999999" >"$PL_FILENAME.json"
    jq . "$PL_FILENAME.json" >"$PL_FILENAME.pretty.json"
done;
