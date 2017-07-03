## Synopsis
This project maintains the customized configuration files as well as additional LUA scripts for the mpv.io mpv player.

## Motivation
The default, out-of-the-box, configuration of mpv.io is rather loaded with GUI parameters that make it more appealing to the masses, but much less akin to the original mplayer.  As mplayer and mpv are great tools for command line, a lot of the GUI-related controls can be removed, resulting in a cleaner interface.

## Installation
The configuration files should be put in the location where mpv looks for configuration files.

For OSX:
~/.config/mpv/
~/.config/mpv/scripts/

For Windows:
C:¥Users¥USERNAME¥AppData¥Roaming¥mpv¥

## Usage
The LUA scripts included perform the following utility:

plstat.lua: List media playlist in the Terminal OSD.  Invoked by 'c'.
resize.lua: Instantaneously resize video width to 480px.  Inovked by 'y'.
status.lua: Clear and rearrange the Terminal OSD for more succinct output.

## Tests
All configuration files and scripts were written and tested within the OSX environment.  Files may work in other operating systems, but will have to be put into their respective folders.

