#!/usr/bin/env bash
set -euo pipefail

read_point() {
    local point
    point=$(slurp -p)
    IFS=, read -r REPLY_X REPLY_Y <<< "${point%% *}"
}

read_point
x1=$REPLY_X
y1=$REPLY_Y

read_point
x2=$REPLY_X
y2=$REPLY_Y

x=$(( x1 < x2 ? x1 : x2 ))
y=$(( y1 < y2 ? y1 : y2 ))
w=$(( x1 > x2 ? x1 - x2 : x2 - x1 ))
h=$(( y1 > y2 ? y1 - y2 : y2 - y1 ))

(( w > 0 && h > 0 )) || exit 1

grim -g "$x,$y ${w}x${h}"

