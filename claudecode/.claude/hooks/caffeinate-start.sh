#!/bin/bash
# UserPromptSubmit: marks the main turn as an active reason to stay awake.
source ~/.claude/hooks/caffeinate-lib.sh
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
marker_dir="/tmp/claude-caffeinate-markers-${session_id}"
pidfile="/tmp/claude-caffeinate-${session_id}.pid"

mkdir -p "$marker_dir"
touch "${marker_dir}/main-turn"
caffeinate_ensure_running "$pidfile"
