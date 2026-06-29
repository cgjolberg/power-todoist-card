# power-todoist-card — guide for Claude Code

Part of the Home Assistant **file/code lane** workspace. See [`OVERVIEW.md`](OVERVIEW.md)
for the full factual snapshot, and [`../CLAUDE.md`](../CLAUDE.md) for workspace-wide rules
(incl. the full push/deploy autonomy policy).

## What this repo is
A single hand-authored Lovelace card: `powertodoist-card.js` **is** the shipped artifact —
**no `package.json`, no bundler, no build step.** Edit that file directly; it's what deploys.
Card type `custom:powertodoist-card`. The Todoist token lives in HA's `secrets.yaml`
(`!secret todoist_api_token`) — **never** paste a real token into this repo or a card config.

## Deploy & push (Claude does this end-to-end)
`.\deploy.cmd` `scp`s the `.js` to the HA box and **auto-bumps** the Lovelace resource (no
manual `?v=` edit; `-NoBump` to skip, `-DryRun` to preview). Passwordless SSH
(`~/.ssh/ha_deploy`) + self-signed-cert trust (`NODE_EXTRA_CA_CERTS`) make it
non-interactive; `git push` to GitHub is non-interactive via Git Credential Manager. Per the
root **autonomy policy**: commit with a reviewed diff, then push to GitHub and deploy to HA
to complete the task — no separate approval; review via git history. No history rewriting
without an explicit instruction. See [`OVERVIEW.md`](OVERVIEW.md).

**Run it prompt-free (allowlisted in [`../.claude/settings.json`](../.claude/settings.json), 2026-06-28):**
invoke as **standalone, forward-slash, `cd`-free** commands — in-repo `git push origin main` then
`./deploy.cmd`, or from the workspace root `git -C ./power-todoist-card push origin main` then
`./power-todoist-card/deploy.cmd`. A `cd`-prefixed, back-slashed (`.\deploy.cmd`), or piped/chained
form won't match the allowlist and will prompt. Force-push and `upstream` pushes are deliberately
left to prompt.

## Working plan: read PLAN.md first, keep it updated
[`PLAN.md`](PLAN.md) is the persistent record of what we're doing in this repo — current
focus, next steps, open questions, decisions, and a dated log. **Read it at the start of any
work here** (the workspace `SessionStart` hook also auto-prints its *Current focus* + *Next
steps*). **Update it as part of every change, in the same commit** as the work: keep *Current
focus* honest, move finished items out of *Next steps*, and append to the *Log*. This is how
we avoid losing track when we bounce between projects.

## Standing rule: keep docs current without being asked
On any change that affects deploy, push/credentials, the secrets handling, or card behavior,
update [`OVERVIEW.md`](OVERVIEW.md) (and bump its `> Snapshot:` date) in the **same commit** —
and if the deploy/push story changed, also the `card-deploy-setup` memory and
[`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md). Derive dates/status from `git`; don't
invent them. Fixing a doc the code has outgrown is in scope even when only code was asked for.
