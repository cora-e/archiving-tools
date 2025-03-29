#!/bin/bash

while IFS="" read -r p || [ -n "$p" ]
do
  #if [[ $p == *"/publications/usip-peace-terms-glossary"* ]]; then
  #  continue
  #fi
  # This time we didn't grep for front quote
  #p2=${p#"\""}
  p2=${p%"\""}
  #echo "www.usip.org/${p2%/*}"
  mkdir -p "www.usip.org/${p2%/*}"
  curl_ff100 "https://www.usip.org/${p2}" -o www.usip.org/${p2}
  sleep 1
done < files_uniq.txt
