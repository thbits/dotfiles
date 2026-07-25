#!/bin/bash
# Shared helpers for the caffeinate hooks. Sourced, not executed directly.

caffeinate_ensure_running() {
  local pidfile="$1"
  if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile" 2>/dev/null)" 2>/dev/null; then
    return 0
  fi
  nohup caffeinate -d -i >/dev/null 2>&1 &
  disown
  echo $! > "$pidfile"
}

# Kills caffeinate only if no markers (main turn or in-flight background
# agents) remain in marker_dir -- this is the reference count.
caffeinate_maybe_kill() {
  local marker_dir="$1" pidfile="$2"
  if [[ -d "$marker_dir" ]] && [[ -n "$(ls -A "$marker_dir" 2>/dev/null)" ]]; then
    return 0
  fi
  if [[ -f "$pidfile" ]]; then
    kill "$(cat "$pidfile")" 2>/dev/null
    rm -f "$pidfile"
  fi
}
