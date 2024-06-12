#!/usr/bin/sh

current_monitor=$(hyprctl activeworkspace | grep -oP 'monitorID: \K\d')
if [[ -z $(eww active-windows | grep 'powermenu$') ]]; then
    eww open powermenu --screen $current_monitor
    echo "open"
elif [[ -n $(eww active-windows | grep 'powermenu$') ]];then
    eww close powermenu
    echo "close"
fi
