#!/bin/bash

configfile="$HOME/.november.conf"
configfile_secured='/tmp/november.cfg'
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
    echo "  stop"
    echo "  toggle"
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
        echo "  ffmpeg"
        echo "Optional dependencies:"
        echo "  notify-send (for notifications)"
        exit 1
    fi
}

depend "ffmpeg"

if [ ! -f $configfile ]; then
    echo "No configuration file found, I've created one for you at $configfile"
    echo "Please edit the configuration and start November again"
    cp "$nov_dir/november.sample.conf" "$configfile"
    exit 1
fi

if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
    egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
    configfile="$configfile_secured"
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
    *)
        echo 'Unknown option. Run -h to see help.'
        exit 1
        ;;
esac

