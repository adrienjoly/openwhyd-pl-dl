# This script downloads all the tracks of all playlists of an OpenWhyd profile.
# Based on openwhyd-dl
# * Playlist and track order are maintained using numbered prefixes
# * Failed downloads are logged into a file
# syntax: ./openwhyd-pl-dl.sh https://openwhyd.org/adrien

PROFILE_URL=$1

DOWNLOAD_SCRIPT="$(echo $PROFILE_URL | tr -dc '[:alnum:]\n\r').sh"
rm $DOWNLOAD_SCRIPT >/dev/null 2>/dev/null

echo "Fetching list of playlists from $PROFILE_URL/playlists ..."
curl -sS "$PROFILE_URL/playlists?format=list" \
  | sed -n 's/.*\"\(\/u\/[^/]*\/playlist\/[0-9]*\)\"[^>]*\>\([^<]*\).*/\1,\2/p' \
  | while read PL ; do
    PL_URL=${PL%%,*} # extract playlist URL
    PL_NAME=${PL#*,} # extract playlist name
    PL_NUM=${PL_URL##*/} # extract playlist number
    PL_NUM=$(printf "%03d\n" $PL_NUM) # 0-padding
    PL_NAME=$(echo $PL_NAME | tr -dc '[:alnum:]\n\r') # remove special characters
    PL_PATH="$PL_NUM - $PL_NAME"
    echo "- $PL_URL => $PL_PATH"
    echo "mkdir \"$PL_PATH\"; cd \"$PL_PATH\"; ../openwhyd-dl.sh \"https://openwhyd.org$PL_URL\"; cd .." >>$DOWNLOAD_SCRIPT
done;

chmod a+x $DOWNLOAD_SCRIPT
echo "Download script is ready!"
echo "run ./$DOWNLOAD_SCRIPT"
