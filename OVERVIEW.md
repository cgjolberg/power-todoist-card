# power-todoist-card — Repo Overview

> Snapshot: 2026-06-19. Part of the Home Assistant **file/code lane** workspace.
> The root [`../CLAUDE.md`](../CLAUDE.md) is the authority on workspace-wide rules;
> this file is a quick factual overview of *this repo*. Refresh it when the build,
> deploy target, or remotes change.

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
- Switch: `-DryRun`.
- After deploy, **bump the Lovelace resource query string** (e.g. `?v=dev5`).

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
- ⚠️ **No `.gitattributes` and no `.editorconfig`**, while `core.autocrlf=true`.
  Since the shipped `.js` is committed directly, this risks CRLF creeping into the
  deployed file. Recommended: add a `.gitattributes` pinning `eol=lf` (copy the one
  from `../detailed-weather-forecast`).
