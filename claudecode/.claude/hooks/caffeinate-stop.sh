#!/bin/bash
# Stop: main turn ended. Only releases caffeinate if no background agents
# are still marked as running.
source ~/.claude/hooks/caffeinate-lib.sh
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
marker_dir="/tmp/claude-caffeinate-markers-${session_id}"
pidfile="/tmp/claude-caffeinate-${session_id}.pid"

rm -f "${marker_dir}/main-turn"
caffeinate_maybe_kill "$marker_dir" "$pidfile"
