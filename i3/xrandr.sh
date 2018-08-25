#!/bin/bash

intern=eDP-1
extern=HDMI-3
intern_res=1920x1200

if xrandr | grep "$extern disconnected"; then
    xrandr --output "$extern" --off --output "$intern" --mode "$intern_res"
else
    xrandr --output "$intern" --off --output "$extern" --auto
fi

