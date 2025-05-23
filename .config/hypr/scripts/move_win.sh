#!/usr/bin/sh

if hyprctl activewindow | grep -q 'floating: 1'; then
  if [ "$1" = "l" ]; then
    hyprctl dispatch moveactive -30 0
  elif [ "$1" = "d" ]; then
    hyprctl dispatch moveactive 0 30
  elif [ "$1" = "u" ]; then
    hyprctl dispatch moveactive 0 -30
  elif [ "$1" = "r" ]; then
    hyprctl dispatch moveactive 30 0
  fi
else
  hyprctl dispatch movewindow $1
fi
