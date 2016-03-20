#!/bin/bash

configfile="$HOME/.november.conf"
nov_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
last_shot_path="$nov_dir/last_shot"
last_cast_path="$nov_dir/last_cast"
imgur_delete_url="$nov_dir/delete_links.txt"
imgur_api_key="35901feee992bbd"

if [ "$1" == "help" ] || [ "$1" == '' ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "November-helper"
    echo "Usage: $(basename $0) [option]"
    echo
    echo "Options:"
    echo "  cast - open last screencast (player specified in ~/.november.confi)"
    echo "  shot - open last screenshot"
    echo "  imgur - upload last screenshot to imgur and copy link"
    echo
    echo "All imgur image links and deletion links are stored in $nov_dir/imgur_links.txt"
    echo
    echo "You need to configure November before usage, see https://github.com/nibogd/november"
    exit
fi

depend() {
    if ! command -v "$1" >/dev/null; then
        echo "You don't have $1 installed but it is required for November"
        echo
        echo "Dependencies for taking screenshots:"
        echo "  maim, slop"
        echo "Optional dependencies:"
        echo "  xclip (for copying to clipboard),"
        echo "  imagemagick (for shadows on screenshots),"
        echo "  notify-send (for notifications)"
        echo
        echo "Dependencies for recording videos:"
        echo "  ffmpeg, slop"
        echo "Optional dependencies:"
        echo "  notify-send (for notifications)"
        echo
        echo "Dependencies for helper:"
        echo "  curl,"
        echo "  an image viewer (preferably feh),"
        echo "  a video player (preferably mpv)"
        echo "  (the former are specified in ~/.november.conf)"
        echo "Optional dependencies:"
        echo "  xclip (for copying links to clipboard)"
        exit 1
    fi
}

depend "curl"

if [ ! -f $configfile ]; then
    echo "No configuration file found, I've created one for you at $configfile"
    echo "Please edit the configuration and start November again"
    cp "$nov_dir/november.sample.conf" "$configfile"
    exit 1
fi

source "$configfile"

imgur() {
    resp=`curl -H "Authorization: Client-ID $imgur_api_key" -F "image=@$1" https://api.imgur.com/3/image.xml 2>/dev/null`
    if [ $? -ne 0 ] || [ `echo $resp | grep -c "success=\"0\""` -gt 0 ]; then
        echo "Upload failed" >&2
        errors=true
        url="Upload to imgur failed"
    else
        url=`echo $resp | sed -rne 's/.*<link>([A-Za-z0-9:\/.]*).*/\1 /p'`
        deleteurl="http://imgur.com/delete/`echo $resp | sed -rne 's/.*<deletehash>([A-Za-z0-9:\/.]*).*/\1 /p'`"
        echo "$1 -- $url -- $deleteurl" >> $imgur_delete_url
    fi


    if command -v "xclip" >/dev/null; then
        echo $url | xclip -selection clipboard
    fi
}

case $1 in
    shot)
        file="`cat $last_shot_path`"
        $image_viewer "$file" &
        if command -v "xclip" >/dev/null; then
            xclip -selection clipboard -t image/png < $file &
        fi
        ;;
    cast)
        $video_player "`cat $last_cast_path`" &
        ;;
    imgur)
        imgur `cat $last_shot_path`
        ;;
    *)
        echo 'Unknown option. Run -h to see help.'
        exit 1
        ;;
esac

