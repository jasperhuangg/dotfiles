---
name: azci-sweep
description: End-to-end workflow for assigned AZ CI Failure issues: discover issues, launch isolated worktree subagents, fix tests/prompts, validate 7/7 stability, open and babysit PRs, handle unrelated smoke flakes by filing AZ CI Failure issues, and maintain az-ci-failure-pr-map.md. Use when the user asks to run all AZ CI failures at once.
---

# AZ CI Failure Sweep

## Purpose

Run the full AZ CI Failure pipeline with minimal user intervention:

1. Find all open AZ CI Failure issues assigned to the user.
2. Create one isolated subagent per issue (own worktree).
3. Diagnose failure source (assertion strictness vs behavior bug).
4. Implement minimal fix, verify 7/7 stability, open PR, babysit to review-ready.
5. Keep `az-ci-failure-pr-map.md` updated continuously.

## Required Output

- Single tracker file: `az-ci-failure-pr-map.md`
- Each row maps issue -> PR -> current status.
- Final response points user to `@Expensidev/az-ci-failure-pr-map.md`.

## Non-Negotiable Rules

1. **One issue, one isolated worktree**: use `best-of-n-runner` subagents.
2. **No base contamination** for any genuinely new PR:
   - Start from clean `main`.
   - If dirty: stash first (`--include-untracked`).
3. **Do not recreate base-fix PRs** if user says they already handled base issues.
4. **Test-only PR policy**:
   - Use No QA treatment.
   - No `InternalQA` label.
   - No QA instructions in PR body.
5. **Behavior PR policy**:
   - `InternalQA` allowed/expected when applicable.
6. **7/7 requirement**:
   - Run the failing path at least 7 times and record outcomes.
   - If local VM is unstable, CI rerun evidence is acceptable.
7. **Unrelated smoke flake policy**:
   - If smoke fails for unrelated unsuppressed method, run AZ CI Failure issue flow:
     - identify method from logs,
     - dedupe existing open issue by exact method,
     - create missing issue with template/labels/assignee,
     - rerun failed jobs/workflow.
8. **Merge conflict policy**:
   - Check PR `mergeStateStatus`.
   - If `DIRTY`: merge `main`, resolve conflicts, push, re-babysit.

## Sweep Workflow

Copy this checklist and update it during execution:

```text
AZCI Sweep Progress
- [ ] Discover assigned open AZ CI Failure issues
- [ ] Initialize/update az-ci-failure-pr-map.md
- [ ] Launch one best-of-n subagent per issue
- [ ] Each subagent: classify root cause and patch
- [ ] Each subagent: verify 7/7 (or capture blocker)
- [ ] Each subagent: open PR + babysit
- [ ] Handle unrelated smoke flakes via AZ CI Failure issues
- [ ] Resolve PR merge conflicts (if any)
- [ ] Final tracker refresh and summary
```

### 1) Discover Issues

Use GitHub search for assigned open issues with label `AZ CI Failure`.

### 2) Initialize Tracker

Create/update `az-ci-failure-pr-map.md` with columns:

- Issue
- Title
- PR
- Status

### 3) Fan Out Subagents

Launch one `best-of-n-runner` subagent per issue with strict scope:

- inspect latest CI failure logs,
- decide `assertion-too-strict` vs `behavior-failure`,
- apply minimal fix,
- run 7 attempts,
- open PR,
- babysit checks and bot comments.

Required subagent return payload:

- Issue URL
- Root cause
- Decision type
- Files changed
- 7-run command + per-run results
- PR URL
- Babysit outcome
- Final status (`DONE` or `BLOCKED`)

### 4) PR Creation Guardrails

Before any new PR branch:

1. Ensure repo clean (`git status --porcelain`).
2. If dirty, stash tracked + untracked.
3. Sync `main`.
4. Branch from `main`.

If user explicitly says base was already fixed manually, do **not** recreate those PRs.

### 5) Babysit Rules

- Resolve actionable bot comments.
- Keep responses prefixed when required by user convention.
- Re-run checks after each push.
- For unresolved ambiguity or risky broad changes, stop and ask user.

### 6) Unrelated Smoke Flakes

When smoke fails on unrelated tests:

1. Parse failed job logs for unsuppressed method.
2. Confirm failure is unrelated to PR diff.
3. Search for open AZ CI Failure issue for exact method.
4. If missing, create issue in `Expensify/Expensify` with proper labels/assignee/template.
5. Rerun failed workflow/jobs and verify suppression path.

### 7) Merge Conflict Handling

For each active PR:

1. Check `mergeStateStatus`.
2. If `DIRTY`, merge `main` into PR branch.
3. Resolve conflicts minimally.
4. Push and babysit checks to green.
5. Update tracker status.

## Status Wording Standard

Use concise tracker statuses:

- `Done (7/7 reruns passed; checks green)`
- `In progress (checks green; N/7 reruns complete)`
- `Blocked (<precise blocker>)`
- `In progress (merging main + resolving conflicts)`

## Completion Criteria

The sweep is complete when:

1. Every assigned AZ CI issue has a row in `az-ci-failure-pr-map.md`.
2. Every row has either:
   - `Done`, or
   - `Blocked` with precise blocker and next action.
3. All opened PRs are babysat to settled checks (or explicitly blocked).
4. Tracker is the source of truth and is up to date at handoff time.
