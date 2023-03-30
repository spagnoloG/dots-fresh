#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

active_monitors=$(xrandr -q | grep " connected" | cut -d ' ' -f1)

# Check if DisplayPort-0 is in the list of active monitors
if echo "$active_monitors" | grep -q "DisplayPort-0"; then
    # launch polybar on DisplayPort-0
    polybar  monitor_lj &
fi

# check if eDP is in the list of active monitors
if echo "$active_monitors" | grep -q "eDP"; then
    # launch polybar on eDP
    polybar laptop_screen &
fi
