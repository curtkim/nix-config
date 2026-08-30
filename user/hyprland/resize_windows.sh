#!/usr/bin/env bash
# 왼쪽/오른쪽으로 나란히 타일된 두 window의 width 비율을 조절한다.
# 사용법: resize_windows.sh <left-window-width-percent>
#
# Hyprland 0.55 (lua config) 부터 `hyprctl dispatch` 는 lua 로 파싱되므로
# `resizeactive exact 50% 50%` 같은 예전 문법은 더 이상 동작하지 않는다.
# 대신 hl.dsp.window.resize({ x = <px>, y = <px>, exact = true }) 를 쓰는데
# x/y 가 숫자(px)만 받기 때문에 percent 를 여기서 px 로 환산한다.
# tiled window 의 exact resize 는 오른쪽 window 에 걸면 방향이 뒤집히므로
# 항상 왼쪽 window 로 focus 를 옮겨서 조절한다.
set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "Usage: $0 <left-window-width-percent>"
    exit 1
fi

P="$1"

active_json=$(hyprctl activewindow -j)
monitor_id=$(echo "$active_json" | jq '.monitor')
mon_json=$(hyprctl monitors -j | jq --argjson id "$monitor_id" '.[] | select(.id == $id)')

# 논리 좌표계 기준 monitor 영역 (scale 적용, waybar 등 reserved 영역 제외)
scale=$(echo "$mon_json" | jq '.scale')
mon_x=$(echo "$mon_json" | jq '.x')
mon_w=$(echo "$mon_json" | jq --argjson s "$scale" '(.width / $s) | round')
res_l=$(echo "$mon_json" | jq '.reserved[0]')
res_r=$(echo "$mon_json" | jq '.reserved[2]')
usable_x=$((mon_x + res_l))
usable_w=$((mon_w - res_l - res_r))

left_w=$((usable_w * P / 100))

# active window 의 중심이 monitor 중앙보다 왼쪽이면 왼쪽 window 로 판단
win_x=$(echo "$active_json" | jq '.at[0]')
win_w=$(echo "$active_json" | jq '.size[0]')
win_h=$(echo "$active_json" | jq '.size[1]')
win_center=$((win_x + win_w / 2))

resize_left() {
    local h="$1"
    hyprctl dispatch "hl.dsp.window.resize({ x = $left_w, y = $h, exact = true })"
}

if [ "$win_center" -lt $((usable_x + usable_w / 2)) ]; then
    resize_left "$win_h"
else
    hyprctl dispatch 'hl.dsp.focus({ direction = "left" })'
    resize_left "$(hyprctl activewindow -j | jq '.size[1]')"
    hyprctl dispatch 'hl.dsp.focus({ direction = "right" })'
fi
