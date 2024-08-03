#!/usr/bin/sh

screenshot="$(slurp | grim -g - -)"

if [ $? -eq 0 ]; then
  echo "$screenshot" | wl-copy
  notify-send --icon photo "Screenshot copied"
fi
