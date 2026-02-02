# usage
# playerctl.sh {previous, next, play-pause}
# -> runs:
# swayosd-client --playerctl={previous, next, play-pause} --player=$(eww get current_music_player)
# playerctl.sh position 5+
# -> runs:
# playerctl position 5+ --player=$(eww get current_music_player) && swayosd-client --custom-message="+5 seconds"
# playerctl.sh toggle-loop
# -> toggles through "None", "Track", or "Playlist" by checking current loop status with `playerctl loop` and setting the next one with `playerctl loop {None, Track, Playlist}`, and displays an osd message with swayosd-client

#!/bin/bash
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
