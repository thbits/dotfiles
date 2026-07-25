#!/bin/bash
# SubagentStop: fires when a subagent's actual work finishes (confirmed
# empirically -- not when the launching tool call merely returns). Clears
# that agent's marker; releases caffeinate only if nothing else is marked.
source ~/.claude/hooks/caffeinate-lib.sh
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
agent_id=$(echo "$input" | jq -r '.agent_id // empty')

marker_dir="/tmp/claude-caffeinate-markers-${session_id}"
pidfile="/tmp/claude-caffeinate-${session_id}.pid"

[[ -n "$agent_id" ]] && rm -f "${marker_dir}/agent-${agent_id}"
caffeinate_maybe_kill "$marker_dir" "$pidfile"
