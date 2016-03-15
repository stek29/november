#!/bin/bash

savedir=$HOME/Pictures/Screenshots

nov_dir="$HOME/.config/bspwm/november"
last=`cat $nov_dir/path`
apikey=`cat $nov_dir/imgur_key`

while read line
do
    if echo $line | grep -F = &>/dev/null
    then
        varname=$(echo "$line" | cut -d '=' -f 1)
        config[$varname]=$(echo "$line" | cut -d '=' -f 2-)
    fi
done < november.conf

# check curl is available
type curl >/dev/null 2>/dev/null || {
   echo "Couln't find curl, which is required." >&2
   exit 17
}

clip=""

file="$1"

# check file exists
if [ ! -f "$file" ]; then
    echo "file '$file' doesn't exist, skipping" >&2
    errors=true
    continue
fi

# upload the image
response=$(curl -F "key=$apikey" -H "Expect: " -F "image=@$file" \
    http://imgur.com/api/upload.xml 2>/dev/null)
# the "Expect: " header is to get around a problem when using this through 
# the Squid proxy. Not sure if it's a Squid bug or what.
if [ $? -ne 0 ]; then
    echo "Upload failed" >&2
    errors=true
    continue
elif [ $(echo $response | grep -c "<error_msg>") -gt 0 ]; then
    echo "Error message from imgur:" >&2
    echo $response | sed -r 's/.*<error_msg>(.*)<\/error_msg>.*/\1/' >&2
    errors=true
    continue
fi

# parse the response and output our stuff
url=$(echo $response | sed -r 's/.*<original_image>(.*)<\/original_image>.*/\1/')
deleteurl=$(echo $response | sed -r 's/.*<delete_page>(.*)<\/delete_page>.*/\1/')
echo $url
echo "$deleteurl" >&2

# append the URL to a string so we can put them all on the clipboard later
clip="$clip$url
"

# put the URLs on the clipboard if we have xsel or xclip
if [ $DISPLAY ]; then
    { type xsel >/dev/null 2>/dev/null && echo -n $clip | xsel; } \
        || { type xclip >/dev/null 2>/dev/null && echo -n $clip | xclip; } \
        || echo "Haven't copied to the clipboard: no xsel or xclip" >&2
else
    echo "Haven't copied to the clipboard: no \$DISPLAY" >&2
fi



ask() {
    kdialog 
}

if [ "$1" == open ]; then
    feh "$last" &
    xclip -selection clipboard -t image/png < $file &
fi

if [ "$2" == upload ]; then
    upload()
fi

