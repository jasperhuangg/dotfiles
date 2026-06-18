---
name: babysit-pr
description: After a pull request is opened, monitor it until CI and bots settle, then respond to actionable bot comments — reply with the "(Jasper's Agent)" prefix and fix & push when the fix is clear and low-risk. Use right after creating a PR, or on demand to babysit an existing PR (optionally pass a PR number or URL). Skips routine bot noise (codecov, dependabot, imgbot, version bumps, green CI); never auto-responds to human comments.
---

# Babysit a Pull Request

Creating a PR is the start of a monitoring loop, not the end of the task. This skill watches a
PR until CI and bots have settled and handles the bot feedback that lands afterward.

## Which PR

- If a PR number or URL was passed, use it.
- Otherwise use the PR for the current branch (`gh pr view --json number,url`).
- Right after `gh pr create`, that's the PR you just opened.

## Monitor until checks settle

Poll the PR until every CI check has concluded (none queued or in progress) and the bots have
stopped commenting:

- `gh pr checks <number>` — check run status.
- `gh pr view <number> --comments` plus the review-thread API — new comments.

CI can take a while. For long gaps, use `ScheduleWakeup` to resume later instead of blocking the
session. Re-check after each of your own pushes, since a push restarts CI.

## Web-Expensify PHP: Psalm and Phan are required gates

When the PR is in **Web-Expensify** and touches `.php` files, the `Psalm` and `Phan` CI checks are
mandatory — don't treat the PR as settled until both have passed. Rely on CI rather than running
them locally: Phan is slow and token-heavy, and the VM's `vssh` Psalm/Phan only see the main
checkout, not worktrees.

- Wait for both `Psalm` and `Phan` in `gh pr checks <number>` to conclude.
- On failure, fetch the output (`gh run view <run-id> --log-failed`), fix the **root cause** in the
  files the PR changed only (pre-existing errors in untouched files are out of scope), and push a
  follow-up commit (never amend/force-push). Re-check after CI re-runs, and repeat until both pass.

## Respond only to actionable bot comments

Respond only to comments that flag a problem or request something. Skip routine noise.

| Respond (actionable) | Skip (routine) |
| --- | --- |
| Failing-check explanations | codecov coverage reports |
| Reviewer / author checklist gates | dependabot dependency bumps |
| Proposal Police violations | imgbot image optimizations |
| Deploy-blocker notes | OSBotify version bumps |
| Code-review suggestions (Copilot / codex-review) | plain green CI status |

The set of accounts that count as "bots" is defined in the **GitHub Conversation Replies**
section of `~/.claude/CLAUDE.md`.

## How to respond

- **Fix and push when the fix is clear and low-risk** (lint, formatting, a checklist item, a
  small suggested edit): make the change, commit, and push as new commits (never force-push
  unless asked), then reply in the thread describing the fix.
- **For ambiguous, subjective, or large fixes:** draft the change and ask the user first instead
  of pushing.
- **Reply with the `(Jasper's Agent) ` prefix.** Bot comments may be answered directly; human
  comments follow the CLAUDE.md rule — draft in chat, never auto-post. If a comment's author type
  is uncertain, treat it as human.

## Stop conditions

Stop when checks have settled and no actionable bot comments remain, then summarize what was
addressed. Also stop and surface to the user if progress stalls, a fix is unclear, or you'd be
pushing repeatedly without converging.
