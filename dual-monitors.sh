#!/bin/sh
if [ `xrandr --listactivemonitors | head -n1 | cut -d' ' -f2` = "1" ]; then
    xrandr \
        --output eDP-1 --mode 1680x1050 --pos 0x390 --rotate normal --primary
else
    xrandr \
        --output eDP-1 --mode 1680x1050 --pos 0x390 --rotate normal \
        --output HDMI-3 --primary --mode 2560x1440 --pos 1680x0 --rotate normal
fi
