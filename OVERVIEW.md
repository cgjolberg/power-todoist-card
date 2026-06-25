# power-todoist-card — Repo Overview

> Snapshot: 2026-06-25. Part of the Home Assistant **file/code lane** workspace.
> The root [`../CLAUDE.md`](../CLAUDE.md) is the authority on workspace-wide rules
> (incl. the **push/deploy autonomy policy**); this file is a quick factual overview
> of *this repo*. **Keep it current** — see *Keeping this file current* at the bottom.

## Purpose
A Lovelace **custom card** (`custom:powertodoist-card`) that shows items from
selected Todoist projects in Home Assistant, with rich per-action behavior
(close/edit/label/move/delete, prompts, toasts, filters). Used on the kitchen
tablet for family tasks. Uses the Todoist API (not affiliated with Doist).

## Tech stack
- **Single hand-authored file:** `powertodoist-card.js` *is* the shipped artifact.
- **No `package.json`, no bundler, no build step.** Plain JS custom element.
- HACS-published (`hacs.json`). Has `MIGRATION.md` and `todoist_demo.yaml` examples.

## Build
None. Edit `powertodoist-card.js` directly; that file is what gets deployed.

## Deploy (dev channel)
```powershell
.\deploy.cmd            # wrapper -> deploy.ps1 -> scripts\deploy-ha-dev.ps1
```
- Mechanism: `scp` the `.js` straight to the HA box (no build).
- **Target:** `root@homeassistant.local:/homeassistant/www/custom-cards/power-todoist-card-dev/powertodoist-card.js`
  (served at `/local/custom-cards/power-todoist-card-dev/powertodoist-card.js`).
- Switches: `-DryRun`, `-NoBump`.
- **The deploy auto-bumps the Lovelace resource** `?v=devN` for you via
  `scripts/bump-ha-resource.mjs` (no manual edit needed; pass `-NoBump` to skip).
- **Claude runs the whole deploy end-to-end.** Passwordless SSH key `~/.ssh/ha_deploy`
  reaches `root@homeassistant.local`, and the bumper trusts HA's self-signed cert via
  `NODE_EXTRA_CA_CERTS` — so no manual credential/SSH/SSL step is required. (Machine-specific
  setup is in the `card-deploy-setup` memory, not in this repo.)

## Push (GitHub)
`git push` to `origin` is **non-interactive** — HTTPS auth is cached in Git Credential
Manager — so Claude can commit and push without a manual auth prompt. Per the root
autonomy policy, Claude commits with a reviewed diff, then pushes/deploys to complete a
task (no separate approval); review via git history.

## Secrets / Todoist token
- The Todoist **API token is NOT stored in this repo.** README/`MIGRATION.md`
  instruct the user to keep it in Home Assistant's `secrets.yaml`
  (`!secret todoist_api_token`, format `Bearer <token>`). Keep it that way —
  never paste a real token into this repo or a card config.

## Git
- `origin` → `github.com/cgjolberg/power-todoist-card.git`. (Upstream lineage is
  `pgorod/power-todoist-card`; no `upstream` remote set locally.)
- **Forgejo:** this workspace repo pushes to **GitHub only** — by design. Forgejo
  backs up the **HA server's own config** (a separate lane, reachable via the
  home-assistant MCP), not these card repos. See [`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md).
- Branch `main`. As of snapshot: clean working tree.

## Repo-specific notes
- **`group_by: assignee` (added 2026-06-25).** Splits one card's list into per-assignee
  sub-sections with headers, using `assignee_labels` (unmapped/none → "Unassigned"). Render
  path: `render()` → `groupItemsByAssignee()` → per-group `renderItem()`. Tunables:
  `group_order`, `group_unassigned_label`, `hide_empty_groups`. See README → *Grouping by
  Assignee*. Used by the kitchen dashboard's Family Tasks card.
- **Line endings — enforced.** A committed [`.gitattributes`](.gitattributes) pins
  `* text=auto eol=lf` (plus explicit source types), so the shipped `powertodoist-card.js`
  stays LF even though it's committed directly and the local `core.autocrlf=true`. No
  `.editorconfig`. *(Added 2026-06-19, mirroring `../detailed-weather-forecast`.)*

## Keeping this file current
Treat docs as part of every change here — update them in the **same commit**, not as a
"if I remember" follow-up. Before committing, check these still read true and fix the ones
that don't (derive dates/status from `git`, never invent them):
- This `OVERVIEW.md` — purpose, **deploy/push mechanism + target**, switches, secrets note,
  and the `> Snapshot:` line (bump to today when you touch the repo).
- **When the deploy/push story changes** (the SSH key, the auto-bump, credential auth,
  resource ID, or the target path), update the Deploy/Push sections here **and** the
  `card-deploy-setup` memory **and** [`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md).
- If a *workspace-wide* fact changes, flag [`../CLAUDE.md`](../CLAUDE.md) (shared root).
