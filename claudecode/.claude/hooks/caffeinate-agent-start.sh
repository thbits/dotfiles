#!/bin/bash
# SubagentStart: a background (or foreground) subagent began real work --
# mark it as an active reason to stay awake, keyed by its agent_id so
# concurrent agents don't clobber each other's marker.
source ~/.claude/hooks/caffeinate-lib.sh
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
agent_id=$(echo "$input" | jq -r '.agent_id // empty')
[[ -z "$agent_id" ]] && exit 0

marker_dir="/tmp/claude-caffeinate-markers-${session_id}"
pidfile="/tmp/claude-caffeinate-${session_id}.pid"

mkdir -p "$marker_dir"
touch "${marker_dir}/agent-${agent_id}"
caffeinate_ensure_running "$pidfile"
