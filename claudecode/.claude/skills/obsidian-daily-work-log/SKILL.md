---
name: obsidian-daily-work-log
description: Use when asked what was worked on on a given day, or to log/journal a day's work into the Obsidian daily note — "what did I work on yesterday", "add this to yesterday's daily note", "fill in the work section", "update my journal". Covers reconstructing the day from Claude Code transcripts, git history and hindsight, and writing the Work callout in the BrainOps vault.
---

# Obsidian Daily Work Log

Reconstruct what actually happened on a calendar day and write it into that day's daily note in the `BrainOps` vault, in the house style: a handful of terse one-line highlights with `[[wikilinks]]` on general topics.

Three failure modes dominate: **link spellings fork** (`[[Karpenter]]` when the vault says `[[karpenter]]`), **the note bloats** into a 13-bullet changelog, and **the day reads as a clean success** because git only records what shipped, not what it cost or what stayed unproven. Steps 3, 4 and the recall pass in Step 1 exist to stop those.

## Vault facts

| | |
|---|---|
| Vault | `/Users/tomhalo/personal/obsidian/BrainOps` |
| Daily note | `03 Daily Journal/YYYY/MM/YYYY-MM-DD (dddd).md` — create `YYYY/MM/` if missing |
| Template | `Templates/Work Daily Journal Template.md` (`- Old.md` is dead, ignore) |
| Resolved topic notes | `01 Work/Projects/`, `01 Work/Manuals/`, `01 Work/Procedures/`, `00 Inbox/` |
| Aliases | none anywhere — a link resolves only on exact filename match |
| Weekly notes / Dataview | not in use, nothing rolls these up |

The work section is **not a heading** — it's a collapsed callout, first block after frontmatter:

```
>[!note]- 🛠️  Work
> **Highlights**
> - 
> 
> **Up Next**
> - 
```

Two spaces after `🛠️`. Every line inside needs its leading `>` or the callout breaks. Separator lines are a **bare `>` with no trailing space** — the template has a trailing space there, the template is wrong, follow the real notes. Frontmatter is `title: YYYY-MM-DD - Daily Journal` (some 2026-04 notes use `YYYY-MM-DD (dddd)`; don't).

Timezone: the user is in Israel. Transcript timestamps are UTC, so the local day is `previous day 21:00Z → target day 21:00Z` under **IDT** (UTC+3, roughly late March to late October) and `22:00Z → 22:00Z` under **IST** (UTC+2, winter). Derive it, don't assume:

```bash
date -j -f '%Y-%m-%d %H:%M' "$DAY 12:00" +%z   # +0300 → 21:00Z window, +0200 → 22:00Z
```

Report times to the user in local time; never put times in the note.

## Multi-day runs

"do it for 6,9 august" is a normal request. Do the link inventory (Step 3) and the house-style read (Step 2) **once**, then reconstruct and compose each day separately. Before writing, diff the days against each other: a thread that spans both belongs to whichever day it actually moved on, split by phase (build vs verify vs roll back), never the same sentence twice.

## Step 1 — Reconstruct the day

### 1. Git history — what shipped, and the end state

`git log --all --author=<user> -i --since --until` across `~/git/*` (also check `~/personal/git/*`), then a second pass with `%b` for full bodies. Commit bodies are the densest source in the whole pipeline — causes, measurements, and explicit "known gap" notes.

`--all` pulls feature branches, so the same work can appear two or three times: dedupe identical subjects across branches, and treat a same-day commit-and-revert pair as one story whose outcome is the revert. Exclude other people's commits and drop stash noise (`WIP on`, `index on`).

Git is authoritative on **end state**. Where it disagrees with a memory about how something ended, git wins.

### 2. Claude Code transcripts — intent and the threads that left no commit

Top-level `~/.claude/projects/*/*.jsonl` (skip `subagents/`); pull `type == "user"` entries in the UTC window, drop ones whose text starts with `<` or is a skill/command preamble. First prompts of each session give the thread of the day; the repo is in the directory name. This is where exploration, reading and investigation live — work with no artifact.

### 3. `agent_knowledge_recall` — the outcome layer

**Run this. It is not optional, and it is not a fallback for when the other two look thin.** Git and transcripts together produce a confident, coherent, and quietly wrong day: they record that a thing was applied, not that it was applied unverified with a rollback plan sitting ready; that a rollout reached prod, not that it deadlocked on the way and had to be unwedged by hand; that a DB was copied, not that the copy only held because of a write-freeze. Every one of those was invisible until recall.

Query per theme, not per day — one query for each thread git and the transcripts surfaced. Name the concrete entities (env, service, resource, error string) **and** ask for the consequence: `"<thing> ... why / rollback / outcome / what happened after"`.

Recall's output blows the token cap, so hit the daemon directly and save to a file rather than calling the MCP tool:

```bash
curl -s -m 180 -X POST http://127.0.0.1:9077/v1/default/banks/claude_code/memories/recall \
  -H 'Content-Type: application/json' \
  -d '{"query":"...","types":["world","experience","observation"],"prefer_observations":true,
       "budget":"high","max_tokens":6000,"query_timestamp":"<target day>T12:00:00"}' \
  > recall/<theme>.json
```

Then extract `results[].text` filtered to the window (`occurred_start` or `mentioned_at`), keyword-filtered per theme and deduped on the first 80 chars — raw dumps are ~120KB each. If the daemon is down, fall back to the `agent_knowledge_recall` tool.

Expect noise: recall over-retains whatever documentation got read that day, and its mid-day snapshots can contradict the end state. A theme returning nothing is itself a finding worth reporting — it means the reasoning was never written down anywhere.

### 4. `progress.md` ledgers

`.superpowers/sdd/*/progress.md` in repos, for the state of multi-task plans. Check when a day's work was plan-driven; skip otherwise.

Group the raw material by theme, not by session — one theme usually spans several sessions.

## Step 2 — Read the house style

Read the target note (it usually does not exist — the habit lapses for months at a time) and 2–3 of the most recent populated daily notes with `cat -A`, so you're matching real bytes rather than this file's description of them. Match what you find there, not what this file says, if they disagree.

Read the **adjacent days'** notes if they exist, for two reasons:

- **De-duplication.** Work spans midnight and sessions get logged a day late: if the neighbour already claims a thread, log the other half of it here (implementation vs verification), not the same sentence twice.
- **The previous note's Up Next is a lookup list.** Those items are the threads most likely to have moved on the target day; go looking for each one specifically. It also tells you which items to stop carrying forward.

## Step 3 — Link inventory (REQUIRED before writing any link)

Never invent a spelling. Get the vault's existing targets first:

```bash
cd "/Users/tomhalo/personal/obsidian/BrainOps"
grep -rho '\[\[[^]]*\]\]' --include='*.md' . | grep -v '/\.trash/' \
  | sed 's/\[\[//; s/\]\]//; s/|.*//; s/#.*//' | sort | uniq -c | sort -rn
find . -name '*.md' -not -path './.trash/*' | sed 's|.*/||; s|\.md$||' | sort
```

Quote `--include='*.md'` — zsh eats it otherwise. Check both lists: a real note filename with no inbound links is still the vault's spelling (that's how `Grafana Operator` is settled).

For every topic you intend to link: if a case/hyphen/space-insensitive match exists, **use that exact string**. Only coin a new one when there is genuinely no match. This skill deliberately carries no list of known spellings — one goes stale within weeks and then quietly authorises a wrong link. The grep is the only source.

Convention for new coinages: products capitalized (`Grafana`, `Terraform`), repos and CLI tools lowercase (`litellm`, `open-webui`, `karpenter`).

When a topic is central to the day, has no existing spelling, and the casing is genuinely ambiguous (a brand name sitting among lowercase repo neighbours), leave it as plain text and **name it to the user** as a one-line question. Don't silently drop it and don't guess.

**Links to notes that don't exist are correct here.** Most of the vault's links are orphans — `[[datalake]]` has 12 links and no file. The point is the graph, not resolution. Never create stub notes to satisfy a link.

## Step 4 — Compose the Highlights

Each bullet is: one line, one theme, plain prose, past tense, 1–2 `[[links]]` at most.

```
> - [[Hermes Agent]]: fixed the dev flow and tested it end-to-end in Slack; verified graceful drain and pod-kill recovery
> - Upgraded the [[open-webui]] chart to 16.0.0 and watched the rollout through [[ArgoCD]]
> - Tooling: moved to [[git worktrees]] (lazygit + a `wt` helper), folded the Argo agent into the [[k8s]] agent
```

- **5–8 bullets.** A busy day is 15+ threads; collapse them. Two bullets on the same system merge. Small housekeeping merges into one `Tooling:` bullet.
- **Carry the outcome, not just the action.** If recall surfaced a caveat, a manual intervention, or a precondition that made it work, that is the half worth remembering — "applied but never proved behind auth" beats "applied", and it costs the same line.
- **Prefix with a bold-free `topic:` label** when grouping helps. No sub-headings, no nesting, no tables, no checkboxes, no tags, no timestamps, no PR numbers, no `**bold**` mid-sentence.
- Enough detail to recognise the work in six months; not a changelog. If a bullet needs a semicolon *and* a dash, it's two bullets or it's too long.
- The cap forces real omissions. **Tell the user what you cut**, in chat, so they can call any of it back — never silently.
- Backtick anything starting with `#` — a bare `#alerts-devops` becomes an Obsidian tag.

## Step 5 — Up Next

Only concrete actions with an identifiable next step. Usually 0–2 items; **empty is a valid and common answer** — leave the template's `> - ` placeholder alone rather than filling it.

An unverified change is a legitimate Up Next when the verification is a specific act ("prove the swap with an authenticated request — rollback is one line in `prod-il.tf`"), not when it's a vague intention to keep watching.

Not Up Next: status narration, things handed to someone else, things explicitly ruled out of scope, "keep an eye on X", restating an unfinished highlight.

## Step 6 — Write and verify

**Build the exact bytes first, then hand over a copy — never a retype.** Trailing spaces, bare `>` separators and the `🛠️`+two-spaces sequence do not survive being passed through a model as literal text to reproduce.

1. Write each finished note to the scratchpad with a Python heredoc (explicit `\U0001f6e0️` escapes beat pasted emoji).
2. Delegate to the `obsidian-knowledge-extractor` agent (per the user's global instructions) with the `cp` commands spelled out, and instruct it explicitly not to retype, reformat or "improve" the content.
3. Have it verify with `diff <scratchpad> <vault file>` and report the exit code — byte-identical or it didn't work. `cat -A` output is a sanity check on top, not the proof.
4. Have it confirm exactly the intended files changed: no stub notes, no edits elsewhere. The vault is not a git repo; a find-by-mtime scan is the check. `.obsidian/workspace.json` changing on its own is normal, that's the running app.

Amending a note after it's written follows the same path: edit the scratchpad copy, re-`cp`, re-`diff`.

## Common mistakes

| Mistake | Fix |
|---|---|
| `[[Karpenter]]`, `[[Jira]]` invented on the spot | Step 3 grep is not optional. Reuse or don't link. |
| 13 bullets, 40-word sentences, `**bold**` mid-line | 5–8 one-liners. Merge themes. |
| Skipping recall because git and transcripts already agree | They agree on the clean version. Recall holds the caveats, reversals and manual interventions. |
| Handing the agent literal content to retype | Stage bytes in the scratchpad, `cp`, `diff`. |
| Up Next padded with status ("X stays unapplied, so...") | Actions only, or leave it empty. |
| Times written into the note | The note is dateless prose. Times go in chat, in local time. |
| Assuming a 21:00Z window in winter | Derive the offset from the date; IST is UTC+2. |
| Creating stub notes so links resolve | Orphan links are the vault's norm. |
| Appending under a `## Work` heading | There is no such heading — it's a `>[!note]-` callout. |
| Reading only transcripts | Git log is where the outcomes and numbers are. |
