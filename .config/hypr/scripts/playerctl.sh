#!/bin/sh

PLAYER=$(eww get current_music_player)
COMMAND=$1

if [[ "$COMMAND" == "position" ]]; then
    OFFSET=$2
    playerctl position "$OFFSET" --player="$PLAYER"
    swayosd-client --custom-message="${OFFSET} seconds"
elif [[ "$COMMAND" == "toggle-loop" ]]; then
    CURRENT_LOOP=$(playerctl loop --player="$PLAYER")
    if [[ "$CURRENT_LOOP" == "None" ]]; then
        playerctl loop Playlist --player="$PLAYER"
        swayosd-client --custom-message="Loop: Playlist"
    elif [[ "$CURRENT_LOOP" == "Playlist" ]]; then
        playerctl loop Track --player="$PLAYER"
        swayosd-client --custom-message="Loop: Track"
    elif [[ "$CURRENT_LOOP" == "Track" ]]; then
        playerctl loop None --player="$PLAYER"
        swayosd-client --custom-message="Loop: None"
    fi
else
    swayosd-client --playerctl="$COMMAND" --player="$PLAYER"
fi
