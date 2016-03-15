#!/bin/bash

savedir=$HOME/Pictures/Screenshots

nov_dir="$HOME/.config/bspwm/november"
last_path="$nov_dir/path"
if [ "$1" == "help" ]; then
  echo "help"
  exit
fi
if [ "$1" == "screen" ]; then
  timestamp=`date +Screenshot_%Y%m%d_%H%M%S`
  file="$savedir/$timestamp.png"
  maim $file
  xclip -selection clipboard -t image/png < $file
  notify-send 'Screenshot' "Saved to $file!"
  echo "$file" > $last_path
fi
if [ "$1" == "window" ]; then
  timestamp=`date +Screenshot_%Y%m%d_%H%M%S`
  file="$savedir/$timestamp.png"
  maim -i $(xdotool getactivewindow) $file
  convert $file \( +clone -background black -shadow 80x20+0+15 \) +swap -background transparent -layers merge +repage $file 
  xclip -selection clipboard -t image/png < $file
  notify-send 'Screenshot' "Saved to $file!"
  echo "$file" > $last_path
fi
if [ "$1" == "selection" ]; then
  timestamp=`date +Screenshot_%Y%m%d_%H%M%S`
  file="$savedir/$timestamp.png"
  maim -i $(xdotool getactivewindow) -s $file
  #convert $file \( +clone -background black -shadow 80x20+0+15 \) +swap -background transparent -layers merge +repage $file 
  xclip -selection clipboard -t image/png < $file
  notify-send 'Screenshot' "Saved to $file!"
  echo "$file" > $last_path
fi

