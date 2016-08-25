# November
An extremely simple screenshooting and screen recording tool (frontend for maim and ffmpeg)

![A sample screenshot](http://i.imgur.com/qiTVix7.png)

## Features
 - Configure only once, no need to pass parameters each time
 - Add shadows to your screenshots
 - Capture the whole screen, a window or selection
 - Record videos via ffmpeg
 - Save screenshots into timestamped files (e. g. `Screenshot_20160320_171923.png`)
 - Upload your screenshots to imgur
 - Send your screenshots to a group, a channel or a human in Telegram directly from November
 
## Dependencies

Dependencies for taking screenshots:
 - maim
 - slop
 - xclip (optional, for copying to clipboard)
 - imagemagick (optional, for shadows)
 - notify-send (optional, for notifications)

Dependencies for recording videos:
 - ffmpeg
 - slop
 - xdpyinfo
 - notify-send (optional, for notifications)

Dependencies for helper:
 - curl
 - an image viewer (preferably feh) and a video player (preferably mpv)
   (the former are specified in ~/.november.conf)
 - xclip (optional, for copying links to clipboard)
 

## Installation
Install the dependencies (read above)

Clone this repo wherever you like:
```
$ git clone https://github.com/nibogd/november.git ~/.november/
```

Start November once to create a config file:
```
$ cd ~/.november/
$ ./november window
No configuration file found, I've created one for you at /home/user/.november.sh
Please edit the configuration and start November again
```

Edit the configuration with your favourite editor:
```
$ vim ~/.november.conf
```

Remap your keyboard shortcuts (use the tool in your DE or WM). In a usual setup you can map the following hotkeys:
 - Print: `$HOME/.november/november screen`
 - Alt + Print: `$HOME/.november/november window`
 - Shift + Print: `$HOME/.november/november selection`
 - Super + Print: `$HOME/.november/november-video toggle`

So that <kbd>PrtScr</kbd>, <kbd>Alt</kbd> + <kbd>PrtScr</kbd>, <kbd>Shift</kbd> + <kbd>PrtScr</kbd>, <kbd>Super</kbd> + <kbd>PrtScr</kbd> will take a screenshot of the whole screen, of a window, of a selection and toggle recording of a whole screen video respectively.

Other commands you can map:
 - `$HOME/.november/november-video toggle-selection`: will ask you to select an area and start recording a video (stop on the second press)
 - `$HOME/.november/november-helper imgur`: will upload the last taken screenshot to imgur and copy the link to the clipboard (and insert a filepath, an imgur link and a deletion link to `$HOME/.november/imgur_links.txt`)
 - `$HOME/.november/november-helper shot`: will open last screenshot with an image viewer selected in `.november.conf`
 - `$HOME/.november/november-helper cast`: will open last screencast with a video player selected in `.november.conf`

## Imgur
Use `~/.november/november-helper imgur` (bind a key or an alias for that). It will upload the latest screenshot to imgur and copy the link to clipboard. You can find all links (and deletion links!) in `~/.november/imgur_links.txt`.

## Telegram
### How to use:
You must fill in your groups', channels' or people's ids
to use Telegram integration.

 1. Create a bot using @botfather bot in Telegram
 2. Enter the bot token into `~/.november.conf` file
 3. Run `~/.november/november-helper telegram` once, this will create a config file
 3. Get somehow needed ids and enter them into `~/.november/telegram.txt` file like this one:
```
chats["me"]=123456789
```
 4. Send screenshots to them via `~/.november/november-helper telegram me`

### How to get the ids:
 - Use the web-version of telegram, the id will be visible in the address bar
 - Use a bot which tells you your id (you can search for them at http://storebot.me)

## Rofi
Bind a key to `~/.november/november-rofi` (you must have `rofi` installed). After pressing that key a dialog will appear:
![rofi](http://i.imgur.com/CV1CmbO.png)

November uses your system rofi settings (colors, placement, etc). See [rofi homepage](https://davedavenport.github.io/rofi/).

## Roadmap
 - [x] Add ability to record part-screen videos
 - [x] Add Imgur integration
 - [x] Add Telegram integration
 - [x] Add Rofi menu integration
 - [ ] Write a Vim plugin
