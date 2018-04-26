#! /bin/bash -e

case "$(xset -q|grep LED| awk '{ print $10 }')" in
  "00000000") echo EN ;;
  "00001000") echo BG ;;
  *) echo unknown ;;
esac
