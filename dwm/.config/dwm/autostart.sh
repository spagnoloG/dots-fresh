#!/bin/sh

# Set wallpaper
feh --bg-scale  --randomize ~/pictures/wallpapers/*

# Set java window names
wmname LG3D

# Start slstatus
slstatus &

# Start compositor
picom &
