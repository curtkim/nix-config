Hyprland에서 windows의 크기를 조절하는 bash scrpt를 작성해줘.
1. 파일이름은 resize_windows.sh
2. `resize_windows.sh 50` 처럼 실행. 왼쪽 window width percent를 받음
3. 창 width조절은 아래처럼 함
```
hyprctl dispatch resizeactive exact 20% 80%
```
4. active window가 왼쪽인지 오른쪽인지 따라서 달리처리 해야 함.
5. 다음 결과에서 at[0]을 보고 100이하이면 왼쪽으로 판단함
```
hyprctl activewindow -j
{
    "address": "0x3b8b1c60",
    "mapped": true,
    "hidden": false,
    "at": [3, 33],
    "size": [1194, 1314],
    "workspace": {
        "id": 1,
        "name": "1"
    },
    "floating": false,
    "pseudo": false,
    "monitor": 0,
    "class": "kitty",
    "title": "tmux attach",
    "initialClass": "kitty",
    "initialTitle": "kitty",
    "pid": 2362617,
    "xwayland": false,
    "pinned": false,
    "fullscreen": 0,
    "fullscreenClient": 0,
    "grouped": [],
    "tags": [],
    "swallowing": "0x0",
    "focusHistoryID": 0
}
```
6. 오른쪽에 있다면, 입력받은 window width percent를 100에서 빼서 적용함.

