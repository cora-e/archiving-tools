# archiving-tools
Various tools and tips I've accumulated trying to scrape websites.  Mostly, this exists to document what I've done for my own and others' reference when digging into the final data. It may also be useful as a collection of working examples of downloading data from various types of host sites.

All of the data downloaded with these tools is available through BitTorrent.  I post the torrents to [AcademicTorrents](https://academictorrents.com/browse.php?search=cprather&c6=1) and [SciOp](https://sciop.net/accounts/cprather).

## Disclaimer

If you're looking to archive entire web sites, e.g. with working browse-able pages, etc, nothing here will help much.  There's plenty of tools you can point at those:
* https://github.com/openzim/zimit
* https://github.com/ArchiveBox/archivebox-browser-extension
* https://webrecorder.net/browsertrix/

Tutorials:
* https://sciop.net/docs/scraping/webpages/

Other data download projects:
* https://codeberg.org/antifascistDH/academia-preserver
* https://codeberg.org/nike_hercules/academia-preserver


I am no expert at archiving or packaging web content, plenty of other people do that better.  Instead, I tend to go after datasets (PDF/CSV/etc) made available online, or things which can't be easily scraped.  Generally that means files or folders too large for scraping, data with weird download mechanics, or sites with aggressive rate-limiting or anti-scraping defenses.

## Sites Scraped

### US Institute of Peace (`curl/usip/`)

Site disallowed downloads from normal `curl` or other scrapers (understandable, it was very slow and I had to rate-limit to avoid making it even slower).  However, `curl-impersonate` set to mimic Firefox v100 seemed to do the trick.

The lists were generated by first querying each page of the search results for "all publications."  The HTML responses were then manually searched with `grep` for article URLs, then each article's contents for URLs of files.  Unfortunately I don't still have the exact commands used.

### Institute of Museum and Library Science YouTube (`youtube/`)

Videos themselves were downloaded with [TubeArchivist](https://www.tubearchivist.com/), but needed to be renamed along with their subtitle files. `name_to_title.py` just calls `ffprobe` to do that.

Probably `yt-dlp` can do basically the same thing with less fuss, but I had TA set up already.

### National Center for Homeless Education (`curl/curl_nche.sh`)

Link: https://profiles.nche.seiservices.com/Default.aspx

`ASP.NET` application hosting lots of PDF files.  Unfortunately, they're hidden behind a "Download" button which fires off a very specific HTTP `POST` request, and the endpoint replies with the PDF file data.  If any of that sounds like your problem, 1) I'm sorry, 2) this script might be a good starting point.

Interesting note: Firefox will track web requests and responses in the "Network" tab of the debugger/inspector (`Ctrl+Shift+I`).  Right-clicking any request produces a "copy as `curl`" option, which copies you a perfect `curl` command to replay it.  Very useful!

### Earthdata/ASDC (`wget/download_earthdata.sh`)

Link: https://asdc.larc.nasa.gov/data/

`wget` and not very fancy, just needs an authorization token from a free account.  Will lock your account if you download the whole thing, ask me how I know this.

### Pubchem (none)

Link: ftp://ftp.ncbi.nlm.nih.gov/pubchem/

FTP, open access. `wget -r ftp://ftp.ncbi.nlm.nih.gov/pubchem/`.  About 9TB total!

### National Archives

The US National Archives is very big, and takes way more code to handle.  Separate repository for it all [here](https://github.com/cora-e/nara-archive).  If you're looking for S3 sync/download examples, they're all there.

## Creating Torrents

It's not fast, but `transmission-create` is simple to use and easy to install most anywhere, including servers without GUI.  Sample usage with AcademicTorrents:
```
$ transmission-create -o name.torrent -c "Comment" -t https://academictorrents.com/announce.php Folder/
```
when component datasets are compressed, 

## Running ArchiveTeam Warrior

Even if you're busy trying to download things yourself, it's worth running an instance of [ArchiveTeam Warrior](https://wiki.archiveteam.org/index.php/ArchiveTeam_Warrior) in the background.  I found the "advanced" container-only mode much easier to set up on a server than the VM.
