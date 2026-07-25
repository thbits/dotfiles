#!/bin/bash
# SessionEnd: unconditional safety-net cleanup, regardless of markers --
# nothing should keep the Mac awake after the session itself is gone.
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
marker_dir="/tmp/claude-caffeinate-markers-${session_id}"
pidfile="/tmp/claude-caffeinate-${session_id}.pid"

rm -rf "$marker_dir"
if [[ -f "$pidfile" ]]; then
  kill "$(cat "$pidfile")" 2>/dev/null
  rm -f "$pidfile"
fi
