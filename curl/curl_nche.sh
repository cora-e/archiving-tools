#!/bin/bash

# Download NCHE web pages and PDFs
# The web page downloads are just the raw HTML, so they don't include all necessary
# data to reproduce the original pages (which were archived manually)
#
# Each PDF download is a POST request which must include a realistic ASP.NET "view state"
# (basically, an encoded form of the web browser's session state). If we just pass
# a web browser's capture of `VIEWSTATE`, we only receive PDFs for whatever the browser
# was viewing, regardless of the endpoint or request! 
# So, we have to "browse" each page to get a realistic state to pass.

for state in {1..60}
do
	# "Browse" to the state's page with cURL.  May as well save the results
	curl "https://profiles.nche.seiservices.com/StateProfile.aspx?StateID=${state}" \
		-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0' \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
		-H 'Accept-Language: en-US,en;q=0.5' \
		-H 'Accept-Encoding: gzip, deflate, br, zstd' \
		-H "Referer: https://profiles.nche.seiservices.com/StateProfile.aspx?StateID=${state}" \
		-H 'Content-Type: application/x-www-form-urlencoded' \
		-H 'Origin: https://profiles.nche.seiservices.com' \
		-H 'DNT: 1' \
		-H 'Connection: keep-alive' \
		-H 'Cookie: __AntiXsrfToken=1e2a4b7d05e749fe832996f8b35468d1;' \
		-H 'ASP.NET_SessionId=ftj1gptbkdlposb2jbav1kjf' \
		-H 'Upgrade-Insecure-Requests: 1' \
		-H 'Sec-Fetch-Dest: document' \
		-H 'Sec-Fetch-Mode: navigate' \
		-H 'Sec-Fetch-Site: same-origin' \
		-H 'Sec-Fetch-User: ?1' \
		-H 'Sec-GPC: 1' \
		-H 'Priority: u=0, i' \
		--output "viewpage_${state}.html"

	# Pick out the VIEWSTATE, as we'll need a state which corresponds to the page we loaded
	# This is important to the server in determining which PDFs to send (for some reason)
	VIEWSTATE=$(grep -Eo 'id="__VIEWSTATE".*"' "viewpage_${state}.html")
	#echo RawView: $VIEWSTATE
	# Get just the contents of 'value=', after 'id='
	VIEWSTATE=${VIEWSTATE#*=}
	VIEWSTATE=${VIEWSTATE#*=}
	# And remove quotes!
	VIEWSTATE=${VIEWSTATE#*\"}
	VIEWSTATE=${VIEWSTATE%\"*}
	echo State $state View: $VIEWSTATE

	for year in {0..15}
	do
		# Now request each PDF file, by sending the POST request which would be generated by the download button
		# Note we have to URLencode the ViewState -- it was returned raw as part of the HTML, but apparently
		# ASP.NET does *not* like it that way in POSTs.
		# I mean I guess we did specify the content was 'urlencoded' in a header, so
		curl "https://profiles.nche.seiservices.com/StateProfile.aspx?StateID=${state}" -X POST \
			-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
			-H 'Accept-Language: en-US,en;q=0.5' \
			-H 'Accept-Encoding: gzip, deflate, br, zstd' \
			-H "Referer: https://profiles.nche.seiservices.com/StateProfile.aspx?StateID=${state}" \
			-H 'Content-Type: application/x-www-form-urlencoded' \
			-H 'Origin: https://profiles.nche.seiservices.com' \
			-H 'DNT: 1' \
			-H 'Connection: keep-alive' \
			-H 'Cookie: __AntiXsrfToken=1e2a4b7d05e749fe832996f8b35468d1;' \
			-H 'ASP.NET_SessionId=ftj1gptbkdlposb2jbav1kjf' \
			-H 'Upgrade-Insecure-Requests: 1' \
			-H 'Sec-Fetch-Dest: document' \
			-H 'Sec-Fetch-Mode: navigate' \
			-H 'Sec-Fetch-Site: same-origin' \
			-H 'Sec-Fetch-User: ?1' \
			-H 'Sec-GPC: 1' \
			-H 'Priority: u=0, i' \
			--data-urlencode "__VIEWSTATE=${VIEWSTATE}" \
			--data-raw "__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATEGENERATOR=A365D1BC&__SCROLLPOSITIONX=0&__SCROLLPOSITIONY=2774&__VIEWSTATEENCRYPTED=&ctl00%24MainContent%24ddlConsolidatedSPR=${year}&ctl00%24MainContent%24btndownload=Download" \
      	    --output "StateProfile_${state}_${year}.pdf"
  	done
done
