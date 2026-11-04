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
- Hindsight is your ONLY memory. Nothing else persists between sessions — no context carries over except what's in the hindsight bank.
- Writing is automatic: the Hindsight Coding Agents hooks retain each session on Stop into the shared `claude_code` bank (tagged `project:<repo>`), and inject recalled memories on a session's first prompt — that's orientation, not a lookup. You don't need to save manually; for deliberate writes use `mcp__hindsight-bank__retain` (or `hindsight_ingest_document` for documents and corrections), and the `hindsight_*knowledge_page*` tools for curated knowledge pages.
- When starting work on something, recall first (`mcp__hindsight-bank__recall`): was this already worked on, what was decided, and what happened after? Don't rediscover ground already covered. `hindsight_reflect` is an LLM synthesis (slow, ~40s) — use recall for facts.
- Before asking me a question, recall whether it was already answered. Answered consistently several times → treat that as the answer and proceed. Found only once (or answers conflict) → don't trust it as settled; ask me.
- Treat recall as a working tool used throughout a task, not just a startup step. Whenever uncertainty comes up mid-work — why something is configured this way, whether an approach was already tried, what the right value is — recall before guessing.
- Compose the query with concrete anchors (env, stack, file, resource, error) AND the intent. Recall ranks on keyword + semantic match, so naming the actual entities pulls far better hits than a vague phrase.
- Always pull the outcome, not just the how: query for what was decided AND what happened after — reversals, rollbacks, warnings, "this broke X". `world`-type memories carry the consequence ("… | When: date | Involving: who | outcome"). Surface any negative hit before repeating the action.
- Recall proactively before continuing prior work or mirroring another environment. Triggers: "too", "also", "same as dev", "like we did", "again", or any change echoing another env.
- Recall output blows the token cap (a large entities map trails every response). Save it and extract with jq/python from the file rather than re-querying.

# Git discipline
- Never commit or push unless I explicitly ask. Never force-push.
- No AI attribution in commit messages or PR descriptions (no "Generated with Claude" / Co-Authored-By footers).

# Verify before done
- Before saying a task is complete, run the relevant lint/tests/plan and report the actual output. Never claim "should work" without checking.
- If verification fails, say so plainly with the failing output — don't soften it.
