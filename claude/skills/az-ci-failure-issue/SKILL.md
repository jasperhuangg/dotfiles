---
name: az-ci-failure-issue
description: File an "AZ CI Failure" tracking issue in Expensify/Expensify when an Agent Zero CI check (smoke or targeted tests) fails on a test unrelated to your PR. Filing the issue lets the suite suppress that method on future runs and unblocks every PR. Use when an Agent Zero CI job is red, you've confirmed the failing test is unrelated to your changes, and no open AZ CI Failure issue already covers that test method. Identifies the test author via git blame and assigns them.
---

# File an AZ CI Failure tracking issue

The Agent Zero smoke (Tier 1) and targeted (Tier 2) CI jobs auto-suppress a failing test **only if**
an open `AZ CI Failure` issue in `Expensify/Expensify` mentions the failing **method name**. A failure
with no matching issue makes the workflow **fail**, even when it's a flaky test unrelated to your PR.
This skill files that tracking issue so the suite goes green on re-run and the flake stops blocking
every other PR too.

Use this only after confirming the failure is **unrelated to your PR**. If your PR touches the failing
test file, or your code change plausibly caused the failure, fix the root cause instead — do not file
a suppression issue to dodge your own regression.

## 1. Identify the failing test and confirm it's unrelated

From the failing CI job, get the failing test(s). The job log is reachable even when
`gh run view --log` is empty:

```bash
gh api repos/Expensify/Web-Expensify/actions/jobs/<JOB_ID>/logs 2>&1 \
  | grep -iE "^[0-9]+\) [A-Z].*Test::|not suppressed:|Expected|Failed asserting|Test\.php:[0-9]" \
  | grep -ivE "SCRIPT_NAME"
```

The log ends with a clear verdict — e.g. `UNKNOWN: 1 failure(s) that were not suppressed:` lists the
exact method(s) blocking the workflow. Tests already covered by an issue show as suppressed and need
no action.

Confirm unrelated: the failing test must live in a file your PR does not touch, and exercise a feature
your diff doesn't affect. Read the assertion message and the test method to be sure. State *why* it's
unrelated — you'll put that in the issue body.

## 2. Check for an existing issue (avoid duplicates)

```bash
gh search issues --repo Expensify/Expensify "<testMethodName>" --state open --json title,url
```

If an open `AZ CI Failure` issue already mentions the method, **do not** create a duplicate — just
re-run the job (the suite will now suppress it) and link the existing issue in your PR body if you want
the smart-un-suppression behavior.

## 3. Find the test author (assignee) via git blame

Assign the original author of the failing test method, not whoever last touched the file:

```bash
# Blame the method's declaration + body line range
git log --format='%an <%ae> | %h' -1 -L <START>,<END>:script/manual/path/to/TestFile.php | head -1
# Resolve the commit's GitHub login
gh api repos/Expensify/Web-Expensify/commits/<HASH> --jq '.author.login'
```

## 4. Create the issue

Use the template at `assets/issue-template.md` (filling every placeholder). Title MUST be exactly
`AZ CI Failure: ClassName::testMethodName` — the method name in the title is what the suppression
script matches on.

```bash
gh issue create --repo Expensify/Expensify \
  --title "AZ CI Failure: <ClassName>::<testMethodName>" \
  --body-file <filled-body.md> \
  --label "AZ CI Failure" --label "Engineering" --label "Daily" \
  --assignee <github-login>
```

Labels: `AZ CI Failure`, `Engineering`, `Daily`. (The full-suite/Tier-3 path on `main` uses
`DeployBlocker` + `Hourly` instead; for a PR-side smoke/targeted suppression issue, use the three
labels above.)

## 5. Re-run the failed CI job and verify

```bash
gh run rerun <RUN_ID> --failed
gh pr checks <PR_NUMBER>
```

The previously-unknown failure should now be suppressed. The suite can still flake on a *different*
unrelated test on the next run — if so, repeat for that method. If the same method keeps failing run
after run, it may be genuinely broken (not flaky); surface that to the user rather than re-running
indefinitely.

## Notes

- Filing a GitHub issue and assigning someone is an outward-facing action — only do it when the user
  has asked you to, or has clearly authorized handling the PR's CI to green.
- Background and tier details live in `~/Expensidev/agent-zero-ci-guide.md` if present.
