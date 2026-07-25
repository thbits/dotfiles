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

# Production safety
- Treat production as read-only by default: never apply, delete, restart, scale, or modify anything in prod unless I explicitly ask for that specific change.
- **preprod runs in the AWS prod account** — treat preprod with prod-level caution.
- Before any infra operation, state the target context (AWS profile + region, kubectl context, grafana instance) and verify it's the intended one. Never assume the current context is correct.
- Primary regions: us-east-1, then il-central-1. Check these first when searching for resources.

# Git discipline
- Never commit or push unless I explicitly ask. Never force-push.
- No AI attribution in commit messages or PR descriptions (no "Generated with Claude" / Co-Authored-By footers).

# Verify before done
- Before saying a task is complete, run the relevant lint/tests/plan and report the actual output. Never claim "should work" without checking.
- If verification fails, say so plainly with the failing output — don't soften it.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
