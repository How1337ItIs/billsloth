# Local AI Transition Plan – v0.3

> **Goal:** Gradually shift qualifying assistant tasks from Claude CLI to capable local models—without surprising Bill, exhausting hardware, or compromising auditability. This plan aligns with the GitHub Logic overlay model and the broader neuro‑divergent, token‑efficient philosophy.

---
## 1. Objectives
1. **Coverage Expansion:** Off‑load high‑volume, low‑risk Claude tasks (summaries, code scaffolds) to local inference.
2. **Quality Preservation:** Maintain or improve overall satisfaction score (≥ baseline) through promotion/rollback gates.
3. **Observability:** Persist metrics comparing local vs cloud performance, accuracy, latency, and user sentiment.
4. **Graceful Fallback:** Automatic Claude/manual fallback on local failures or resource exhaustion.
5. **Extendability & Governance:** Multi‑model ensemble ready; registry includes license + SHA‑256; router enforces resource & security checks.

---
## 2. Current State & Gaps
| Area               | Current | Gap | Resolution in v0.3 |
|--------------------|---------|-----|--------------------|
| **Model discovery**| Ad‑hoc Ollama installs | No canonical registry | Introduce `~/.bill‑sloth/ai/registry.json` (overlay snapshot committed) |
| **Router**         | Cloud‑first static | No confidence, no rollback | `lib/router_llm.sh` v2 with promotion, shadow, rollback |
| **Metrics**        | Satisfaction only | No accuracy/latency split | `router_stats.json` aggregated; dashboard + CI check |
| **Security**       | SHA check optional | No license tracking, no temperature guard | Mandatory SHA + license fields; GPU temp & disk guard |
| **Pristine modules** | Partially preserved | Registry risked living under modules | Registry relocated outside repo; core libs read‑only via git flags |

---
## 3. Component Overview
| Component | Purpose | Location / Branch |
|-----------|---------|-------------------|
| **Model Registry** | Metadata, SHA‑256, license, resource needs | `~/.bill‑sloth/ai/registry.json` (overlay snapshot in repo) |
| **Model Store** | Actual binaries from Ollama / GGUF | `~/.bill‑sloth/ai/models/` |
| **Router v2** | Task classification, local/cloud selection, shadow eval, rollback logic | `lib/router_llm.sh` (pristine; `assume-unchanged`) |
| **Shadow Evaluator** | Compare outputs; build accuracy stats | `scripts/shadow_eval.sh` |
| **Confidence Tracker** | Rolling latency & accuracy | `~/.bill‑sloth/ai/router_stats.json` |
| **Budget Monitor** | Tracks remaining Claude credits | `scripts/cloud_budget.sh` |
| **Incident Log** | Captures rollbacks & failures | `~/.bill‑sloth/ai/incidents/<timestamp>.json` |

---
## 4. Model Registry Schema
```jsonc
{
  "version": 1,
  "models": [
    {
      "id": "codellama-7b-instruct",
      "family": "CodeLlama",
      "size_gb": 3.8,
      "capabilities": ["code", "general"],
      "sha256": "abc123…",
      "license": "cc-by-nc-4.0",
      "ram_req_gb": 8,
      "vram_req_gb": 6,
      "status": "downloaded"
    }
  ],
  "task_policies": {
    "summarize":  {"local_preferred": false, "shadow": true},
    "code_gen":  {"local_preferred": false, "shadow": true},
    "adaptation": {"local_preferred": false, "shadow": false}
  }
}
```
*Snapshot copy committed via overlay branch for audit; pristine repo untouched.*

---
## 5. Phased Migration Strategy
| Phase | Trigger | Automated Steps | Bill’s Touchpoint |
|-------|---------|-----------------|-------------------|
| **Bootstrap** | `bill ai init` | Model suggestion → download → registry update | Choose lite/full model |
| **Shadow** | Default | Claude serves; local runs in background; save `shadow_evals` | No visible change |
| **Confidence** | ≥100 shadow pairs; ≥90 % accuracy; <7 s latency | Router flags `LOCAL_AI_CANDIDATE=1`; CI opens PR | Dashboard badge “Local AI candidate ready” |
| **Promotion** | Merge PR; `LOCAL_AI_ENABLED=1` | Local first, Claude fallback with validation | Banner: “Local AI Active” |
| **Rollback** | Δ‑satisfaction < –0.5 **or** accuracy < 85 % **or** GPU temp/disk error | Router disables local for 48 h, logs incident | Notice: “Local AI paused—using Claude” |
| **Enhancement** | Stable 30 days | Add RAG, multi‑model ensemble | Faster, richer answers |

Promotion/rollback statuses sync to `router_stats.json` and surface in dashboard.

---
## 6. Router v2 Highlights
- **Read‑Only:** `lib/router_llm.sh` shipped pristine; installer sets `chmod -w` & `assume-unchanged`.
- **Validation Hooks:** shellcheck/py‑compile (code_gen); length ratio (summarize); generic non‑empty.
- **Resource Guards:** aborts local inference if GPU temp > 85 °C **or** free disk < 5 GB; writes incident.
- **Budget Awareness:** `CLOUD_BUDGET_LEFT` (in USD) exported by `cloud_budget.sh`; router avoids Claude if budget 0 except critical tasks.

---
## 7. Metrics & Compression
- `shadow_evals/*.json` compressed weekly into `shadow_evals/summary-<week>.csv` before commit.
- `router_stats.json` schema:
```json
{"window":"last_100","local":73,"cloud":27,"accuracy":92,"latency_ms":5600,"satisfaction_delta":0.2}
```

---
## 8. CI Additions
### `.github/workflows/local-ai-smoke.yml`
- Pull minimal `phi3` model
- Prompt router “2+2” → expect `4`
- Ensure entry added to `shadow_evals`, registry validates against JSON Schema.

### Registry JSON Schema
Located `schemas/registry.schema.json`; CI validates via `ajv-cli`.

---
## 9. Security Extensions
| Risk | Control |
|------|---------|
| Model tampering | SHA‑256 & optional sigstore verify before marking `status: downloaded`. |
| Ollama port exposure | `OLLAMA_HOST=127.0.0.1` enforced; iptables rule denies external connections. |
| Prompt logs | `sanitize_prompt` hashes and truncates; full text only under `DEBUG_AI`. |
| Resource abuse | Router concurrency cap; abort if >2 local inferences running. |

---
## 10. UX Commands
```
ai status     # Metrics, model info, cloud budget
ai models     # List registry with install size & license
ai switch ID  # Change active model after resource check
ai promote    # Force promotion if candidate ready
```
`first_time_setup.sh` now prints a helper card listing these commands.

---
## 11. Dashboard Unification
“Local AI” section added to migration dashboard; cloud credit meter & Windows‑migration checklist share one screen for simpler cognitive load.

---
## 12. Implementation Timeline
| Sprint | Deliverables |
|--------|-------------|
| **S1** | Registry, hardware detect, router logging, read‑only flag test |
| **S2** | Shadow eval storage & compression, validation hooks, dashboard card |
| **S3** | Auto‑promotion PR automation, rollback hook, CI smoke job |
| **S4** | RAG context layer, multi‑model gating, budget monitor integration |
| **S5** | Local adaptation generation, Claude optional |

---
## 13. Success Criteria
- ≥80 % eligible tasks local within 3 s median latency.
- Δ‑satisfaction ≥ –0.1 using global adaptive score.
- Claude monthly calls reduced ≥70 %.
- Zero unresolved security incidents from local model processes.

---
## 14. Next Action
Ship **Sprint 1**: commit registry initializer & router stubs, update installer to protect core libs, and begin shadow logging.

_End of Local AI Transition Plan v0.3._

