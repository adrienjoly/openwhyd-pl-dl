# openwhyd-pl-dl

A youtube-dl based script to backup your [Openwhyd](http://openwhyd.org) playlists.

## Scripts

- `openwhyd-pl-dl.sh <PROFILE_URL>` downloads all the tracks of all playlists of an Openwhyd profile, as MP3 files.
- `openwhyd-dl.sh <PLAYLIST_URL>` downloads all the tracks of an Openwhyd playlist, as MP3 files.
- `openwhyd-pl-dl-json.sh <PROFILE_URL>` downloads the tracklists of all playlists of an Openwhyd profile, as JSON files.

## Features

- Playlist and track order is maintained using numbered prefixes
- Failed downloads (e.g. deezer tracks, and deleted/broken links) are logged into a file

## Dependencies

- [youtube-dl](rg3.github.io/youtube-dl/), python program to download videos from YouTube.com and a few more sites
- [curl](https://curl.haxx.se/), command line tool for transferring data with URLs
- [jq](https://stedolan.github.io/jq/), lightweight and flexible command-line JSON processor

These scripts were successfully tested on Mac OS 10.11.6 (El Capitan) in August 2016.

## Sample usage

```
./openwhyd-pl-dl.sh https://openwhyd.org/adrien
```
