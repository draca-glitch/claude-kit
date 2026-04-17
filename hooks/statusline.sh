#!/bin/bash
# Custom statusline for Claude Code: host + load + memory + disk + uptime.
# One line, minimal, always-on.
#
# Output example:
#   user@host | load 0.42 | mem 15G/63G | disk 82% | up 7d
#
# Wire via settings.json:
#   "statusLine": {
#     "type": "command",
#     "command": "~/.claude/hooks/statusline.sh",
#     "refreshInterval": 5
#   }

HOST="${USER:-$(whoami)}@$(hostname -s)"
LOAD=$(awk '{printf "%.2f", $1}' /proc/loadavg)
MEM=$(free -g | awk '/^Mem:/ {printf "%dG/%dG", $3, $2}')
DISK=$(df -h / | awk 'NR==2 {print $5}')

UP_SECS=$(awk '{print int($1)}' /proc/uptime)
if   [ "$UP_SECS" -ge 86400 ]; then UP="$((UP_SECS/86400))d"
elif [ "$UP_SECS" -ge 3600  ]; then UP="$((UP_SECS/3600))h"
else                                UP="$((UP_SECS/60))m"
fi

echo "$HOST | load $LOAD | mem $MEM | disk $DISK | up $UP"
