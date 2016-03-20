#!/bin/bash

configfile="$HOME/.november.conf"
nov_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
last_path="$nov_dir/last_shot"

if [ "$1" == "help" ] || [ "$1" == '' ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "November -- a simple screenshooting utility"
    echo "Usage: $(basename $0) [option]"
    echo
    echo "Options:"
    echo "  screen"
    echo "  window"
    echo "  selection"
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

depend "maim"
depend "slop"

if [ ! -f $configfile ]; then
    echo "No configuration file found, I've created one for you at $configfile"
    echo "Please edit the configuration and start November again"
    cp "$nov_dir/november.sample.conf" "$configfile"
    exit 1
fi

source "$configfile"

timestamp=$screenshot_prefix`date +%Y%m%d_%H%M%S`
file="$screenshots_dir/$timestamp.png"
    
case $1 in
    screen)
        maim $file
        code=$?
        if $screen_shadow; then
            convert $file \( +clone -background black -shadow 80x20+0+15 \) +swap -background transparent -layers merge +repage $file 
        fi
        ;;
    window)
        maim -i $(xdotool getactivewindow) $file
        code=$?
        if $window_shadow; then
            convert $file \( +clone -background black -shadow 80x20+0+15 \) +swap -background transparent -layers merge +repage $file 
        fi
        ;;
    selection)
        maim -i $(xdotool getactivewindow) -s $file
        code=$?
        if $selection_shadow; then
            convert $file \( +clone -background black -shadow 80x20+0+15 \) +swap -background transparent -layers merge +repage $file 
        fi
        ;;
    *)
        echo 'Unknown option. Run -h to see help.'
        exit 1
        ;;
esac

if command -v "xclip" >/dev/null; then
    xclip -selection clipboard -t image/png < $file
fi

if command -v "notify-send" >/dev/null; then
   notify-send 'Screenshot' "Saved to $file!"
fi
echo "$file" > $last_path
exit $code

