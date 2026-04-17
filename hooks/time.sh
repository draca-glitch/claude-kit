#!/bin/bash
# UserPromptSubmit hook: inject current server time so Claude has temporal
# cohesion across messages (knows how long between your replies).
#
# Usage in settings.json:
#   "UserPromptSubmit": [{
#     "hooks": [{
#       "type": "command",
#       "command": "~/.claude/hooks/time.sh",
#       "timeout": 2
#     }]
#   }]

date '+%Y-%m-%d %H:%M:%S %Z'
