#!/usr/bin/env python3

import os
import sys
import ffmpeg

print(os.listdir("."))

for media_file in os.listdir("."):
    # Prevents issues with video filenames beginning wtih '-'
    media_file = "./" + media_file

    try:
        probe = ffmpeg.probe(media_file)
    except:
        continue
    if "format" in probe:
        if "tags" in probe["format"]:
            if "title" in probe["format"]["tags"]:
                title = probe["format"]["tags"]["title"]
                title = title.replace(":","_").replace("/","_").replace("<","_").replace(">","_")
                try:
                    os.rename(media_file, title+".mp4")
                    os.rename(media_file.replace(".mp4",".en.vtt"), title+".en.vtt")
                except:
                    pass

