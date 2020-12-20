# This script downloads all the tracks of an OpenWhyd playlist into MP3 files.
# Based on youtube-dl: http://rg3.github.io/youtube-dl/ -- http://rg3.github.io/youtube-dl
# * Track order is maintained using numbered prefixes
# * Failed downloads are logged into a file

WHYD_URL="$1" # e.g. https://openwhyd.org/test/playlist/1
DEST_PATH="./$2"
YOUTUBE_DL_PREFIX="$3"
LOG="${DEST_PATH}/openwhyd-dl.log"
FAILURE_LOG="${DEST_PATH}/openwhyd-dl.failures.log"
rm $LOG $FAILURE_LOG >/dev/null 2>/dev/null

echo "Downloading URLs from $WHYD_URL ..."
echo "Downloading URLs from $WHYD_URL ..." >>$LOG
URLS=$(curl -sS "$WHYD_URL?format=links&limit=999999")

NUMBER=0
for URL in $URLS; do 
  ((NUMBER++))
  NN=$(printf "%05d\n" $NUMBER)
  URL=${URL%#*} # remove the hash part of the URL (prevents downloading soundcloud tracks)
  echo "Downloading media # $NN: $URL ..."
  echo "Downloading media # $NN: $URL ..." >>$LOG
  ${YOUTUBE_DL_PREFIX}youtube-dl $URL >>$LOG 2>>$LOG \
    --verbose --console-title --extract-audio --audio-format mp3 --output "${DEST_PATH}/$NN - %(title)s.%(ext)s"    
  RET=$?
  if [ $RET -ne 0 ]; then
    echo "(i) Failed => appended to $FAILURE_LOG"
    echo "$NN $URL" >>$FAILURE_LOG
  fi;
done;

echo "Done! :-)"
echo "Download log stored in $LOG"
