#!/bin/sh
if upower -i /org/freedesktop/UPower/devices/battery_BAT0 \
    | grep -qE "state:\s+discharging"; then 
  systemctl hibernate;
else
  systemctl suspend;
fi
