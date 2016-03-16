#!/bin/bash

configfile='november.conf'
configfile_secured='/tmp/november.cfg'
nov_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
last_path="$nov_dir/last"

if [ "$1" == "help" ] || [ "$1" == '' ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
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

if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
    egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
    configfile="$configfile_secured"
fi

source "$configfile"

timestamp=`date +Screenshot_%Y%m%d_%H%M%S`
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

xclip -selection clipboard -t image/png < $file
notify-send 'Screenshot' "Saved to $file!"
echo "$file" > $last_path
exit $code

