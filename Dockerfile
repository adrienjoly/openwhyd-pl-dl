FROM alpine:3.8

RUN apk add --no-cache \
    curl \
    bash \
    jq \
    youtube-dl
