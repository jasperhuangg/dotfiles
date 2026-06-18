## Commit Messages

Format: `<type>(<scope>): <subject>`

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `style`, `perf`, `build`

- Subject line only, no body
- Max 72 characters total
- Imperative mood, lowercase, no period
- Scope is optional but encouraged

## GitHub Conversation Replies

Different rules apply based on who authored the comment being replied to:

- **Bot comments** (e.g. MelvinBot, BugZero, GitHub Actions, dependabot, copilot, any account with `[bot]` in the login or `type: "Bot"` from the GitHub API) — the agent may post the reply directly via `gh` or the API. Prefix the body with `(Jasper's Agent) ` so reviewers know it's automated.
- **Human comments** — do NOT post automatically. Draft the proposed reply in chat for Jasper to review, then he sends it manually (or explicitly tells the agent to post it). If he does ask the agent to post on his behalf, still prefix with `(Jasper's Agent) `.

If the author type is uncertain, treat the comment as human and draft in chat.

This applies to PR review-thread replies, PR issue comments, and GitHub issue comments. It does NOT apply to commit messages, PR titles, or PR descriptions.

## Opening Pull Requests
Keep the "Explanation of Change" section of pull request descriptions short. Max 1-2 sentences for each point worth describing in the PR. Focus on a short overview of what each thing the PR changes, and why the change is needed.

## After Creating a Pull Request

Creating a PR is the start of a monitoring loop, not the end of the task. After opening a PR, run the `babysit-pr` skill to watch it until CI and bots settle and to respond to actionable bot comments.
