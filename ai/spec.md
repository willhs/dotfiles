# Documentation Structure Guide

## The /docs directory: documentation and long-term memories 
### Structure

```
/docs
  index.md                 # Entry point + table of contents
  philosophy/
    goals.md               # Why this exists; non-negotiables
    principles.md          # Engineering/product principles
    glossary.md            # Project-specific terms/acronyms
  design/
    identity.md            # Name, tone, brand, visual identity
    design_system.md       # Components, tokens, UX patterns
    architecture.md        # High-level system diagram + flows
    adr/                   # Architecture Decision Records
      0001-title.md
  research/
    topics/                # One file per experiment
      2025-08-31-foo.md
  work/
    roadmap.md             # Now / Next / Later
    tasks/                 # Working docs (agents write here)
      0001-short-title/
        task.md            # Goal, audience, context, solutions
        plan.md            # Implementation plan, files, changes
      0002-another-task/
        task.md
        plan.md
    notes/                 # Meeting notes, scratch pads
      2025-08-31-sync.md
  ops/
    runbook.md             # How to run, debug, recover
    quality.md             # Test strategy, perf SLOs, checklists
    data_contracts.md      # Schemas, SLAs, backward compat rules
  meta/
    docs_manifest.json     # Machine-readable index (see below)
    templates/             # File templates for agents/humans
      adr.md
      task.md
      experiment.md
```

### File front matter (required)

All docs (except `docs_manifest.json`) start with YAML front matter to make them machine-friendly.

```yaml
---
status: draft|active|blocked|done|superseded
agent_write: true|false
summary: "One-liner for embeddings/search"
---

Section order (agents must preserve):
1. Context / Purpose
2. Current State
3. Decisions / Rationale (or Hypotheses for experiments)
4. Next Actions (checkbox list)
5. References / Links
6. Change Log (append-only)

Change Log format: 
- 2025-08-31 (agent:gpt): Added perf test plan draft.
```

### Golden docs (must-reads for agents)

- `docs/index.md` — Quick start, doc map, and "how to contribute".
- `docs/philosophy/goals.md` + `docs/philosophy/principles.md` — Alignment source of truth.
- `docs/design/architecture.md` — Current system shape.
- `docs/work/roadmap.md` — Priorities.
- `docs/ops/runbook.md` — Operational guardrails.

---

### Working docs rules (safe agent writes)

**Agents MAY create/update:**
- `docs/work/tasks/*/task.md` and `docs/work/tasks/*/plan.md`
- `docs/research/experiments/*.md`
- `docs/work/notes/*.md` *(append notes)*

**Agents MUST NOT modify directly** *(human-owned, unless `agent_write: true`):*
- `docs/philosophy/goals.md`
- `docs/philosophy/principles.md`
- `docs/design/identity.md`

**On write, always:**
- Preserve front matter **and** section ordering.
- Append a **Change Log** entry.

---

### When to create/update

- **Task:** > 30 minutes of work, crosses files/services, or involves external comms.
- **ADR:** API surface, storage schema, deployment topology, or cost model decision.
- **Experiment:** Measurable hypothesis **+** success metric.
- **Roadmap:** When Now / Next / Later changes.
- **Runbook:** After any prod issue or on-call learning.
- **Goals/Principles:** Review at the start of each quarter or upon violation.

### Machine-readable index (docs/meta/docs_manifest.json)
```json
{
  "version": 1,
  "generated_at": "2025-08-31T00:00:00Z",
  "entries": [
    { "path": "philosophy/goals.md", "priority": "must_read" },
    { "path": "philosophy/principles.md", "priority": "must_read" },
    { "path": "design/architecture.md", "priority": "must_read" },
    { "path": "work/roadmap.md", "priority": "must_read" }
  ]
}
```

### Templates (/docs/meta/templates/)

#### ADR (adr.md)

```markdown
---
status: proposed
summary: "{{one_liner}}"
---

# Context
# Decision
# Consequences (Positive/Negative)
# Alternatives Considered
# Links

### Change Log
- {{date}} (agent:{{id}}): created
```

#### Task Directory Structure

Each task gets its own directory under `docs/work/tasks/NNNN-short-title/`:

**task.md** (describes the task):
```markdown
---
status: active
summary: "{{one_liner}}"
---

## Context
## Goal
## Audience/Users
## Potential Solutions
## Definition of Done

### Change Log
- {{date}} (agent:{{id}}): created
```

**plan.md** (describes implementation):
```markdown
---
status: draft
summary: "Implementation plan for {{task_name}}"
---

## Architecture & Approach
## Files to Change
## Implementation Steps
- [ ] step 1
- [ ] step 2

## Context & Dependencies
## Risk & Considerations

### Change Log
- {{date}} (agent:{{id}}): created
```

#### Experiment (experiment.md)

```markdown
---
status: draft
summary: "Hypothesis: ..."
---

## Hypothesis
## Metrics & Method
## Results
## Interpretation
## Next Steps

### Change Log
- {{date}} (agent:{{id}}): created
```

### `docs/index.md` (starter)

```markdown
# Project Docs

- Start here: philosophy/goals.md, philosophy/principles.md
- System: design/architecture.md, design/adr/
- Doing: work/roadmap.md, work/tasks/ (task directories)
- Operating: ops/runbook.md, ops/quality.md
- Research: research/landscape.md, research/experiments/

## How to contribute (agents)
- Allowed write paths: `work/tasks/*/` (task.md, plan.md), `research/experiments`, `work/notes`.
- Append Change Log entries.
- Unsure? Propose via a new task in `work/tasks/`.
```

### Automations (recommended)

- **Pre-commit hook**
  - Validate front matter + required headings.
  - Refresh `docs_manifest.json`.
  - Ensure fields: `status`
  - Enforce standard sections for ADRs, tasks, and experiments.

- **Weekly doc review**
  - Scan for stale docs needing review.

- **PR rules**
  - Changes to `/docs/philosophy/**` → **human review required**.
  - Changes to `/docs/work/**` → **agent-authored allowed**.

---

### Naming & IDs

- **Tasks:**
  `docs/work/tasks/NNNN-short-title/` (directory with task.md and plan.md)

- **ADRs:**
  `NNNN-short-title.md` (monotonic, zero-padded).

- **Notes & Experiments:**  
  `YYYY-MM-DD-topic.md`.
