---
description: Sync and verify an ArgoCD rollout after a push (dev | prod | preprod)
argument-hint: <dev|prod|preprod> [app ...] [commit-sha]
---

Launch the `k8s-ops-agent` to run a post-push ArgoCD verification.

Arguments given: `$ARGUMENTS`

Interpret them as: target env (`dev`, `prod`, or `preprod` — preprod lives in the **prod** ArgoCD instance), then optionally specific app names and/or a commit SHA. If no env is given, ask; never assume prod. If no apps are given, derive the affected apps from the pushed commit by matching changed chart directories against each application's `spec.source.path`. If no commit is given, use the most recent commit on `main` in `/Users/tomhalo/git/opmed-charts/`.

The agent should:
1. Announce the target instance, cluster, account, and kubeconfig, and whether preprod apps are in scope.
2. Record the pre-existing `OutOfSync`/unhealthy baseline before attributing anything to this push.
3. Refresh the affected apps (they are all auto-sync, so refresh only shortens the wait) and wait for them to settle — in parallel across apps and regions.
4. Verify per app: `Synced`, `Healthy`, `status.sync.revision` equals the pushed SHA, no degraded/missing resources, workloads actually rolled without CrashLoops or restart climbs, no warning events.
5. Report a clear verdict — "nothing broke", or exactly what needs fixing — with pre-existing drift listed separately.

Do not sync anything whose target revision the user did not push, and do not use destructive sync flags without explicit approval.
