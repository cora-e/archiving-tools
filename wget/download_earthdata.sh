#!/bin/bash

# Get an account and token at https://urs.earthdata.nasa.gov/login
TOKEN="SOME.TOKEN"

# Paths can be entire folders, e.g. MOPITT
for path in "$@"; do
  URL="https://asdc.larc.nasa.gov/data/${path}/"
  # There are lots of index.html.tmp.tmp.tmp type files in the hierarchy.  Unfortunately wget still downloads them, just knows to delete them after
  wget --header "Authorization: Bearer $TOKEN" --recursive --no-parent --reject "index.html*" --execute robots=off $URL
done
# Ill-fated attempt to preview total folder sizes
#wget --header "Authorization: Bearer $TOKEN" --recursive --spider --server-response --no-parent --reject "index.html*" --execute robots=off $URL 2>&1 \
#    | sed -n -e /unspecified/d -e '/^Length: /{s///;s/ .*//;p}' #| paste -s -d+ | bc
