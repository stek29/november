#!/bin/bash

configfile="$HOME/.november.conf"
nov_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
last_path="$nov_dir/last_cast"
pid_path="$nov_dir/ffmpeg_pid"
resolution=`xdpyinfo | grep dimensions | awk '{print $2}'`

if [ "$1" == "help" ] || [ "$1" == '' ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "November-video screen recorder (frontend for ffmpeg)"
    echo
    echo "Usage: $(basename $0) [option]"
    echo
    echo "Options:"
    echo "  record"
    echo "  record-selection"
    echo "  stop"
    echo "  toggle"
    echo "  toggle-selection"
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

depend "ffmpeg"
depend "slop"

if [ ! -f $configfile ]; then
    echo "No configuration file found, I've created one for you at $configfile"
    echo "Please edit the configuration and start November again"
    cp "$nov_dir/november.sample.conf" "$configfile"
    exit 1
fi

source "$configfile"

case $1 in
    record)
        if [ ! -f $pid_path ] || [ "`cat $pid_path`" == '' ]; then
            timestamp=$screencast_prefix`date +%Y%m%d_%H%M%S`
            file="$screenshots_dir/$timestamp.$video_format"

            nohup ffmpeg -video_size $resolution -framerate 25 -f x11grab -i :0.0+0,0 $file >/dev/null 2>&1 &
            PID="$!"
            echo $PID > $pid_path
            echo $file > $last_path
        else
            echo "Already recording a video. If not, just delete the $pid_path file."
            exit 1
        fi
        ;;
    record-selection)
        if [ ! -f $pid_path ] || [ "`cat $pid_path`" == '' ]; then
            timestamp=$screencast_prefix`date +%Y%m%d_%H%M%S`
            file="$screenshots_dir/$timestamp.$video_format"

            eval $(slop)
            nohup ffmpeg -video_size "$W"x"$H" -framerate 25 -f x11grab -i :0.0+$X,$Y $file >/dev/null 2>&1 &
            PID="$!"
            echo $PID > $pid_path
            echo $file > $last_path
        else
            echo "Already recording a video. If not, just delete the $pid_path file."
            exit 1
        fi
        ;;
    stop)
        if [ ! -f $pid_path ] || [ "`cat $pid_path`" == '' ]; then
            echo 'Not recording a video'
            exit 1
        else
            kill "`cat $pid_path`"
            echo "" > $pid_path
            if command -v "notify-send" >/dev/null; then
                notify-send 'Screencast' "Saved to `cat $last_path`!"
            fi
        fi
        ;;
    toggle)
        if [ ! -f $pid_path ] || [ "`cat $pid_path`" == '' ]; then
            timestamp=$screencast_prefix`date +%Y%m%d_%H%M%S`
            file="$screenshots_dir/$timestamp.$video_format"

            nohup ffmpeg -video_size $resolution -framerate 25 -f x11grab -i :0.0+0,0 $file >/dev/null 2>&1 &
            PID="$!"
            echo $PID > $pid_path
            echo $file > $last_path
        else
            kill "`cat $pid_path`"
            echo "" > $pid_path
            if command -v "notify-send" >/dev/null; then
                notify-send 'Screencast' "Saved to `cat $last_path`!"
            fi
        fi
        ;;
    toggle-selection)
        if [ ! -f $pid_path ] || [ "`cat $pid_path`" == '' ]; then
            timestamp=$screencast_prefix`date +%Y%m%d_%H%M%S`
            file="$screenshots_dir/$timestamp.$video_format"

            eval $(slop)
            nohup ffmpeg -video_size "$W"x"$H" -framerate 25 -f x11grab -i :0.0+$X,$Y $file >/dev/null 2>&1 &
            PID="$!"
            echo $PID > $pid_path
            echo $file > $last_path
        else
            kill "`cat $pid_path`"
            echo "" > $pid_path
            if command -v "notify-send" >/dev/null; then
                notify-send 'Screencast' "Saved to `cat $last_path`!"
            fi
        fi
        ;;
    *)
        echo 'Unknown option. Run -h to see help.'
        exit 1
        ;;
esac

