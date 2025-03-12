# 인자 확인: 왼쪽 window width percent를 인자로 받음
if [ -z "$1" ]; then
    echo "Usage: $0 <left-window-width-percent>"
    exit 1
fi

P="$1"

# active window의 정보를 JSON 형태로 가져옴
active_json=$(hyprctl activewindow -j)

# JSON에서 "at" 배열의 첫 번째 값을 추출 (jq 필요)
x_coordinate=$(echo "$active_json" | jq '.at[0]')
left_percent="$P"
right_percent=$((100 - P))

# x_coordinate가 100 이하이면 active window가 왼쪽에 있다고 판단
if [ "$x_coordinate" -le 100 ]; then
    hyprctl dispatch resizeactive exact "${left_percent}%" "${right_percent}%"
else
    hyprctl dispatch movefocus l
    hyprctl dispatch resizeactive exact "${left_percent}%" "${right_percent}%"
    hyprctl dispatch movefocus r
fi
