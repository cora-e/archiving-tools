#!/bin/bash

while IFS="" read -r p || [ -n "$p" ]
do
  if [[ $p == *"/publications/usip-peace-terms-glossary"* ]]; then
    continue
  fi
  p2=${p#"\""}
  p2=${p2%"\""}
  mkdir -p "www.usip.org${p2%/*}"
  curl_ff100 "https://www.usip.org${p2}" -o www.usip.org${p2}
  sleep 2
done < articles_uniq.txt
