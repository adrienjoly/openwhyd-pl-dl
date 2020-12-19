set -e # this script will exit if any command returns a non-null value

PROFILE_URL="https://openwhyd.org/test"

docker build --tag "openwhyd-pl-dl" .
docker run -it --rm \
           -v "$PWD:/app" "openwhyd-pl-dl" \
           "/bin/bash" -c "cd /app; ./openwhyd-pl-dl-json.sh ${PROFILE_URL}"

echo "✅ Done."
