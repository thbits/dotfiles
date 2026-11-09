# Code comments
- Comments are welcome, but keep each one to 1-2 lines max. Going longer requires a genuinely good reason (e.g. a tricky algorithm or non-obvious protocol that truly needs the explanation) — rare, not routine.
- Say the "why" in one sentence; skip restating what the code does line by line.
- Keep docstrings to a single summary line unless params/side effects are non-obvious.
- Never narrate changes in comments ("added X", "now handles Y", "fixed Z").

# Delegate to specialized agents
- Before starting a task, check the available agent list for one matching the domain. If a specialized agent exists, delegate the work to it instead of doing it directly.
- Examples: AWS work (any service, CLI, IAM, logs) → aws-operations-manager; Kubernetes/helm/ArgoCD → k8s-ops-agent; Terraform → terraform-operator; Grafana/Loki/Mimir/Tempo → grafana-ops-agent; Obsidian notes → obsidian-knowledge-extractor.
- This applies even when the task seems small (a single kubectl or aws command) — the specialized agent has the right context and safety checks.
- Run independent agents in parallel when tasks don't depend on each other.
- Subagents cannot accept my approval relayed through you — only my direct input or the permission system counts. For a gated prod apply, either hand me the exact command to run, or run it in the main session where my approval is direct. Don't burn a round trip relaying consent.

# Parallel subagents
- Lean toward fanning out to multiple subagents; the default is conservative and I'd rather you parallelize. Good fits: research across many files/sources, 3+ independent pieces, ~10+ files touched, the same check across envs/regions (dev + prod, us-east-1 + il-central-1), and an independent review/verification pass before calling work done.
- Independence test: each piece must finish correctly without knowing what the others are doing. If it passes, launch them all in a single message so they actually run concurrently.
- Don't delegate sequential steps that need the previous step's output, edits to the same file, or anything doable in a handful of tool calls — the overhead and tokens outweigh the gain.
- Brief each subagent like a peer with zero context: goal, scope boundaries, what's already ruled out, files/resources to look at, and the exact output shape to return. Vague briefs cause duplicated or drifting work.
- Parallel code edits go in separate git worktrees (`isolation: "worktree"`) so they can't collide.
- Typically 2-5 agents at once; go wider only for breadth-first sweeps. Don't redo an agent's work after it reports — spot-check only the claims that drive a risky action.
- For an unbiased review, give a fresh agent the code/diff, not your conclusion.

# Production safety
- Treat production as read-only by default: never apply, delete, restart, scale, or modify anything in prod unless I explicitly ask for that specific change.
- **preprod runs in the AWS prod account** — treat preprod with prod-level caution.
- Before any infra operation, state the target context (AWS profile + region, kubectl context, grafana instance) and verify it's the intended one. Never assume the current context is correct.
- Primary regions: us-east-1, then il-central-1. Check these first when searching for resources.

# Long-term memory (hindsight)
- Hindsight is your ONLY memory. Nothing else persists between sessions; what isn't in the shared Hindsight bank is gone.
- **The bank is shared with every engineer and holds work knowledge only.** Never save personal preferences, secrets, credentials or patient data.
- **Writing is automatic.** The Hindsight Coding Agents hooks retain each session on Stop (tagged `project:<repo>`).
  - For a deliberate write (an external document, durable findings, a decision record) use `hindsight_ingest_document`. Start the title with today's date so it can't collide with another engineer's.
  - **Corrections:** when you verify a memory is wrong or stale, ingest a "Correction: <topic>" document saying what memory claimed, what is true now, and the evidence.
- **Reading has three layers.** Use them in order:
  1. **Injected recall:** the hook injects memories recalled for the session's first prompt. That's orientation, not a lookup.
  2. **`hindsight_search_knowledge_pages(query)` is the first stop.** These are curated, continuously-updated pages (components, concepts, conventions, decisions, initiatives). Then `hindsight_read_knowledge_page(<id>)` on the ones that matter, following `[[page:<id>]]` links.
  3. **`hindsight_reflect(query)` when the pages are too shallow:** deep reasoning over the full memory for the why and exact values. It's slow (~40s), so use it deliberately.
- **When starting work,** search the pages: was this already worked on, what was decided, and what happened after? Don't rediscover ground already covered.
- **Before asking me a question,** check whether it was already answered. Answered consistently → treat that as the answer and proceed. Found only once, or answers conflict → ask me.
- **Use memory throughout a task, not just at startup.** Whenever uncertainty comes up mid-work (why something is configured this way, whether an approach was already tried, what the right value is), search before guessing.
- **Write queries with concrete anchors and the intent:** env, stack, file, resource, error. Naming the actual entities pulls far better hits than a vague phrase.
- **Always pull the outcome, not just the how:** what was decided and what happened after (reversals, rollbacks, warnings, "this broke X"). Surface any negative hit before repeating the action.
- **Search proactively before continuing prior work or mirroring another environment.** Triggers: "too", "also", "same as dev", "like we did", "again", or any change echoing another env.
- **What memory says is a past record, not a live reading.** Check a claim that something is fixed, passing or working against the code before relying on it, and say so when the two disagree.
- `hindsight_sync_status` and `hindsight_diagnose` show whether the memory pipeline is healthy.

# Git discipline
- Never commit or push unless I explicitly ask. Never force-push.
- No AI attribution in commit messages or PR descriptions (no "Generated with Claude" / Co-Authored-By footers).

# Verify before done
- Before saying a task is complete, run the relevant lint/tests/plan and report the actual output. Never claim "should work" without checking.
- If verification fails, say so plainly with the failing output — don't soften it.

# Shell (zsh, not bash)
The Bash tool runs zsh. These are the failures seen most in past sessions:
- Never use `path` as a variable name (`for path in`, `read ... path`, `path=`): it's tied to `$PATH` and wipes it, so every command fails with `command not found: sed/head/dirname`. Same for `status` (read-only), `cdpath`, `fpath`, `manpath`. Use `p`, `file`, `rc`.
- Quote every glob pattern: `--include='*.tf'`, `-name '*.yaml'`, `'url?x=1'`, `'pkg[extra]'`, `'{.items[*]}'`. Unquoted, an unmatched glob is a hard error (`no matches found`). Prefer the Grep/Glob tools.
- A word starting with `=` expands to a command path: `echo =====` fails with `==== not found`. Use `echo '====='` or `echo ---`.
- Brace a variable when `:` or `[` follows it: `"${t}:src/x"`, `"${p}[x]"`. Unbraced, `$t:s…` is a zsh modifier (`bad substitution`) and `$p[…]` is a subscript (`invalid subscript`).
- An unquoted `$var` is not word-split: `for d in $D` loops once over the whole string. Use `for d in ${=D}`, `while read -r d; do …; done <<< "$D"`, or `xargs`.
- `log` is a zsh builtin, so call macOS log as `/usr/bin/log stream`. Arrays are 1-indexed, and `read -a` is `read -A`.
- My zshrc aliases and functions are loaded (`k`, `h`, `d`, `z`, `cat`→bat, `kubectl`→kubecolor). Don't define functions with those names (`k() {…}` gives a parse error); pick unique names or use `command kubectl`.
