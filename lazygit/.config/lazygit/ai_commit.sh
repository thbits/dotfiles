#!/usr/bin/env bash
set -eu

if [ -z "$(git diff --staged --stat)" ]; then
    echo "No staged files!" >&2
    exit 1
fi

PROMPT='5 conventional commit messages, one per line, ordered by likelihood. Format: type(scope)!?: description. Types: fix|feat|refactor|chore|docs|style|test|perf|ci|build. Imperative mood, lowercase, no trailing period, ≤72 chars. Each option meaningfully different (not rephrasings). No vague descriptions (no "update code", "misc changes"). Use ! only for breaking API changes. Example: feat(auth): add refresh-token rotation. Output only the 5 lines — no numbering, no preamble, no commentary.'

RAW=$(
    { git diff --staged --stat; echo "---"; git diff --staged | head -80; } | \
    timeout 30 /Users/tomhalo/.local/bin/claude \
        -p "$PROMPT" \
        --model haiku \
        --output-format text \
        --no-session-persistence \
        --disable-slash-commands \
        --strict-mcp-config \
        --setting-sources user
)

FILTERED=$(printf '%s\n' "$RAW" | grep -E '^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([^)]+\))?!?: .+' || true)

if [ -z "$FILTERED" ]; then
    printf '%s\n' "$RAW"
    exit 0
fi

printf '%s\n' "$FILTERED" | head -5
