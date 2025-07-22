# GitHub Logic – Update & Review Pipeline

This document defines the end‑to‑end workflow for how Bill’s local changes, adaptive overlays, and automated adaptations flow into GitHub for review, sanity checking, and merge—while preserving the project’s goals: **empower Bill**, **maintain stable core modules**, and **enable safe self‑modification**.

---

## 1. Branching Strategy

| Branch                  | Owner                       | Contents                                                                | Notes                                   |
| ----------------------- | --------------------------- | ----------------------------------------------------------------------- | --------------------------------------- |
| `main`                  | You                         | Pristine modules (no adaptations), approved overlays merged via develop | Tag releases (`release-YYYYMMDD`).      |
| `develop`               | You                         | Integration / staging for next release                                  | Auto‑deployed to Bill optionally.       |
| `bill/<date>-session`   | Bill’s machine scripts      | Bill’s overlays (`overlays/*.sh`), preferences, telemetry snapshots     | One branch per day (`bill/2025-07-22`). |
| `automation/adaptation` | Adaptation generator script | New/updated overlays produced from telemetry & satisfaction             | Always PR’d; never auto‑merged.         |

**Rule:** *Only overlays and state files are committed from Bill’s machine.* Core `modules/*.sh` remain read‑only and pristine.

---

## 2. Local Protections (Bill’s Machine)

During installation:

```bash
git update-index --assume-unchanged modules/*.sh  # Prevent accidental edits
chmod -w modules/*.sh                               # Read-only at filesystem level
```

If you need to modify a module locally, revert with `git update-index --no-assume-unchanged` and restore permissions.

---

## 3. Overlay Model

Adaptations never rewrite module sources. Instead they create/modify `overlays/<module>.sh` with functions or menu augmentations. Runtime composition:

```bash
source "modules/<module>.sh"
[ -f "overlays/<module>.sh" ] && source "overlays/<module>.sh"
```

`adaptations/manifest.json` tracks provenance:

```json
{
  "version": 1,
  "modules": {
    "file_mastery_interactive": {
      "base_commit": "<gitsha>",
      "overlays": ["overlays/file_mastery_interactive.sh"],
      "satisfaction": 4.2,
      "last_adaptation": "2025-07-22T09:00:00Z"
    }
  }
}
```

---

## 4. Bill’s Sync Script (`bill-sync.sh`)

Steps executed when Bill wants to push progress:

1. `git fetch origin`.
2. Create/update session branch: `git checkout -B bill/$(date +%Y-%m-%d)`.
3. Rebase onto latest `main`: `git rebase origin/main`.
4. Run smoke tests: `scripts/smoke.sh` (executes each module’s `--quick-start` path).
5. If tests pass, generate commit message via Claude CLI:
   ```bash
   msg=$(claude "Summarize these changed files: $(git diff --name-only)")
   git add overlays preferences.env telemetry.json adaptations/manifest.json
   git commit -m "${msg:-Bill session update}" && git push origin HEAD
   ```
6. If tests fail, create `reports/sync-failure-<timestamp>.md` with logs and still push for your review.

Bill does **not** resolve conflicts manually; the script aborts and instructs him to run `bill-update.sh` first (see §6).

---

## 5. Adaptation Generation (`generate_adaptations.sh`)

Triggered manually or via cron when satisfaction < target.

1. Read telemetry + satisfaction scores.
2. For each low‑scoring module, build adaptation prompt; call Claude (local fallback if offline).
3. Write/update overlay file; update `adaptations/manifest.json` with new hash.
4. Open/update branch `automation/adaptation`.
5. Create/refresh Pull Request with template including:
   - Module name
   - Rationale (score delta)
   - Diff snippet
   - Rollback instructions

No changes to `modules/` are ever staged by this script.

---

## 6. Updating Bill’s Environment (`bill-update.sh`)

Executed when you merge changes to `main` or `develop`.

1. Stash overlay edits: `git stash push -m bill-overlay-temp overlays/*.sh preferences.env`.
2. `git checkout main && git pull`.
3. Apply stashed changes: `git stash pop || true`.
4. Run migration script handling schema/version bumps (e.g., converting mutated modules back to overlay format).
5. Re-run smoke tests + health check; regenerate dashboards.
6. If overlay conflict occurs, script prints Claude prompt for assisted resolution.

---

## 7. Continuous Integration (GitHub Actions)

Workflow triggers on PR to `develop` or `main`:

1. **Checkout** repository.
2. **Lint:** `shellcheck` all `*.sh` (fail on error).
3. **Overlay Composition Test:** For each module, source module+overlay in a subshell; run `--quick-start` if available.
4. **Security Gate:** Ensure only one kill‑switch library; scan overlays for forbidden commands (e.g., `iptables -F` outside library).
5. **Telemetry Schema:** Validate `telemetry.json` / `manifest.json` against JSON Schema.
6. **Pristine Guard:** Fail if any `modules/*.sh` contains adaptation markers or differs from `origin/main` except intentional patch.

Status must be green before merge.

---

## 8. Pull Request Review (You)

PR template checklist:

```
- [ ] CI green
- [ ] Overlays only (no core module mutations)
- [ ] Satisfaction improved or neutral
- [ ] Security gate passed
```

Helper script `scripts/pr_sanity.sh <branch>`:

```bash
#!/usr/bin/env bash
set -e
branch=$1
git fetch origin "$branch" && git checkout "$branch"
./scripts/smoke.sh
python scripts/metrics_diff.py  # optional analytics
```

After review, **squash‑merge** into `develop`. Periodically fast‑forward `develop` → `main` after extended regression (weekly or on demand).

---

## 9. Release & Rollback

Tag release from `main`:

```bash
git tag -s release-YYYYMMDD -m "Bill Sloth Release YYYY-MM-DD" && git push origin --tags
```

Rollback script:

```bash
./scripts/rollback.sh release-YYYYMMDD
# Resets modules; preserves overlays; disables incompatible overlays by renaming *.disabled
```

---

## 10. Sanity Checks & Metrics Gates

Before merging adaptation PRs:

- **Satisfaction Gate:** Reject if new adaptation decreased satisfaction > threshold (e.g., 0.5 drop).
- **Quick‑Start Time:** Profile before/after; reject if startup latency increases >20%.
- **Security Diff:** Static scan ensures no new network listeners or privileged commands.

Metrics persisted in `telemetry.json` allow historical comparison.

---

## 11. Release Notes Automation

Script `scripts/release-notes.sh` compiles:

- Overlay diffs since last tag
- Migration completion % delta
- Local vs cloud token usage ratio
- Security mode changes
- Notable fixes / new capabilities

Appended to `methods_log.md` and published as GitHub Release body.

---

## 12. Future Scaling (Multi‑User)

To generalize beyond Bill:

- Introduce `profiles/<username>/overlays` directories.
- Branch naming `user/<username>/<date>`.
- Central adaptation service processes per‑user telemetry and opens PRs.

Branch & overlay separation already prepare architecture for this expansion without rework.

---

## 13. Alignment with Project Goals

| Goal                   | Mechanism                                                                |
| ---------------------- | ------------------------------------------------------------------------ |
| Empower Bill           | Simple `bill-sync.sh` / `bill-update.sh`; no manual conflict resolution. |
| Stable Core            | Pristine modules; overlays isolated; CI pristine guard.                  |
| Safe Self‑Modification | Adaptations PR‑reviewed; satisfaction & security gates; rollback tags.   |
| Token Efficiency       | Metrics track local\:cloud usage; router optimized based on telemetry.   |
| Windows Migration      | Dashboard & release notes show capability progress.                      |
| Future Ecosystem       | Overlay model + branch strategy scales to multiple users.                |

---

## 14. Next Steps

1. Implement overlay migration script (convert existing mutated modules → overlays).
2. Commit initial CI workflow + schemas.
3. Deliver `bill-sync.sh` and `bill-update.sh` to Bill’s environment.
4. Dry‑run adaptation generation to populate first `automation/adaptation` PR.

Once these are in place, you’ll have a reproducible, auditable pipeline that retains the playful adaptive experience while giving you tight control over what reaches `main`. Let me know when you’d like the actual script/code stubs generated.

