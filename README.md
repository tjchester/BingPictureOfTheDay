# bpod

* [Homepage](https://rubygems.org/gems/bpod)
* [Documentation](http://rubydoc.info/gems/bpod/frames)
* [Source](https://github.com/tjchester/bpod)

## Description

This gem will download the Bing home page image of the day and set it as your desktop wallpaper.

## Features

## Examples

    require 'bpod'

## Requirements

## Install

    $ gem install bpod

## Command Line Tool Usage

```
Usage: bpod [options]
    -i, --image-folder FOLDER        Full file path where images will be stored.
    -r, --region-code REGION         Region code for Bing market area, for example en-US.
    -d, --download-image             Download the image of the day.
    -f, --force-download             Download image even if not within download window.
    -n, --show-notification          Display a desktop notification when wallpaper is changed.
    -s, --set-wallpaper              Set desktop wallpaper using latest downloaded image.
    -v, --verbose                    Display messages about which actions are occurring.
    -h, -?, --help                   Display usage information
```

> The */lib/bpod/region.rb* contains a list of valid region codes.

Bing only changes their home page image once per day so the tool is designed to only attemp a download once a day. The tool will look in your image folder to see if their is an image that has the same date as the current day. If it finds an image meeting that criteria it will not try to download the image again. You can override this behaviour by specifying the *-f or --force-download* option in combination with the *-d / --download-image* option.

If you do not specify any options then the following defaults will be used:

- --region-code en-US
- --download-image
- --set-wallpaper
- --image-folder ~/Pictures/bpod # On windows = C:\Users\username\Pictures\bpod

## Copyright

Copyright (c) 2017 Thomas Chester

See LICENSE.txt for details.
