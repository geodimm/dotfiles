#!/usr/bin/env bash

icon="$HOME/.config/i3/lock.png"
tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 20% -scale 500% "$tmpbg"
case $(xrandr -q | grep -Eo 'current [[:digit:]]+ x [[:digit:]]+' | sed 's/current //; s/ //g') in
    4240x1440)
        convert "$tmpbg" "$icon" -gravity center -geometry +840 -composite -matte "$tmpbg"
        convert "$tmpbg" "$icon" -gravity center -geometry -1280+195 -composite -matte "$tmpbg";;
    *)
        convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg";;
esac
exec i3lock -i "$tmpbg"
