# power-todoist-card — working plan

> **Claude Code's persistent memory of what we're doing in THIS repo.** It survives
> across sessions and across switching to other projects. It is auto-surfaced at the
> start of every session by the workspace `SessionStart` hook (see
> [`../.claude/print-plans.ps1`](../.claude/print-plans.ps1)), and it is **kept current
> as part of every change** — updated in the *same commit* as the work, exactly like
> [`OVERVIEW.md`](OVERVIEW.md). Derive dates from `git`/the clock; never invent them.
>
> Keep it compact. The `## Current focus` + `## Next steps` sections are what the hook
> prints, so they are the at-a-glance "where were we" — prune stale lines aggressively.

## Current focus
_Idle._ Just added `group_by: assignee` (per-assignee sub-sections in one card) for the
kitchen Family Tasks card (2026-06-25). No active task.

## Next steps
- [ ] (none yet)

## Open questions / blockers
- (none)

## Decisions & context worth keeping
- **Grouping is render-time only.** `group_by: assignee` buckets the *already
  filtered/sorted* items in `render()` via `groupItemsByAssignee()`, then reuses the
  extracted `renderItem()` per group. It does not touch filtering/sorting, so it composes
  with `filter_*`/`sort_by_due_date`. Assignee → group via `assignee_labels`; none/unmapped
  → "Unassigned". The per-item template lives in `renderItem()` now (extracted from the old
  inline `items.map`), so edit it there.
- **`filter_labels` can't express "unassigned".** The filter requires a positive include
  match (`(excludes===0) && (includes>0)`) and `!*` ("no labels") is mis-routed to the
  exclude branch, so a one-card-per-person split would silently drop unlabeled+unassigned
  tasks. That's why grouping is a native feature rather than three filtered cards.

## Log
- 2026-06-25 — Added `group_by: assignee` + `group_order` / `group_unassigned_label` /
  `hide_empty_groups`. Extracted the per-item template into `renderItem()`; added
  `groupItemsByAssignee()` and a `.powertodoist-group-header` style; suppress the assignee's
  own chip under its group header. Documented in README (*Grouping by Assignee*) + OVERVIEW.
- 2026-06-20 — PLAN.md created (workspace-wide plan-tracking convention added).
