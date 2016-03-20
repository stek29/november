# November (WORK IN PROGRESS)
An extremely simple screenshooting and screen recording tool (frontend for maim and ffmpeg)

![A sample screenshot](http://i.imgur.com/bi6PF4H.png?1)

## Features
 - Configure only once, no need to pass parameters each time
 - Add shadows to your screenshots
 - Capture the whole screen, a window or selection
 - Record videos via ffmpeg (currently only whole screen videos)
 
## Dependencies
Dependencies for taking screenshots:
 - maim
 - slop

Optional dependencies:
 - xclip (for copying to clipboard)
 - imagemagick (for shadows on screenshots)
 - notify-send (for notifications)

Dependencies for recording videos:
 - ffmpeg

Optional dependencies:
 - notify-send (for notifications)

Dependencies for the helper (imgur upload, etc):
 - curl
Optional dependencies:
 - xclip
 
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

## Roadmap
 - [x] Add ability to record part-screen videos
 - [x] Add Imgur integration
 - [ ] Add Telegram integration
 - [ ] Add Rofi menu integration
