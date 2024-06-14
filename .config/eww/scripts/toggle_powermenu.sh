#!/usr/bin/sh

current_monitor=$(hyprctl activeworkspace | grep -oP 'monitorID: \K\d')
if $(eww active-windows | grep -q 'powermenu$'); then
  eww close powermenu
  echo "close"
else
  eww open powermenu --screen $current_monitor
  echo "open"
fi
