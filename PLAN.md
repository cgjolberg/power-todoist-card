# power-todoist-card — working plan

> **Working plan — auto-printed at session start** by the workspace `SessionStart` hook
> ([`../.claude/print-plans.ps1`](../.claude/print-plans.ps1)). Holds **current state + future
> work only** — sections *Current focus* / *Next steps* / *Open questions* / *Decisions & context
> worth keeping*. Git history is the record of what shipped; completed work is pruned in the same
> commit that ships it. Dates are `YYYY-MM-DD`, newest-first.

## Current focus
_Idle._ No active task.

## Next steps
- (none)

## Open questions
- (none)

## Decisions & context worth keeping
- **2026-06-25 — Grouping is render-time only.** `group_by: assignee` buckets the already
  filtered/sorted items in `render()` via `groupItemsByAssignee()` (assignee → group via
  `assignee_labels`; none/unmapped → "Unassigned"); the per-item template is `renderItem()`.
- **2026-06-25 — `filter_labels` can't express "unassigned"** — it needs a positive include match
  and `!*` mis-routes to the exclude branch, so a one-card-per-person split would silently drop
  unlabeled+unassigned tasks. That's why grouping is a native feature, not three filtered cards.
