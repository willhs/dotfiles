---
id: front-matter
type: reference
purpose: "Describe the doc front matter schema and how to use it."
scope: ["docs"]
non_goals: []
tags: ["front-matter", "schema"]
related: ["meta/front-matter-schema.json"]
---

## Purpose
Explain the required YAML front matter format for persistent docs and point to the schema for validation.

Use the JSON Schema in `docs/meta/front-matter-schema.json` to validate doc headers before committing changes.

## Doc type definitions (authoritative)
### `spec`
Defines intended behavior to build and verify.
Use when the doc contains requirements, acceptance criteria, constraints, edge cases, or "the system must..." statements that implementation should follow.

### `decision`
Records a choice and why it was made (ADR-style).
Use when the doc captures context, considered options, the chosen option, and consequences/tradeoffs so the team/agent doesn't re-litigate later.

### `note`
Exploratory, incomplete, or time-bound working material.
Use for meeting notes, investigations, research assignments, scratch findings, open questions, and partial ideas that are not yet authoritative.

### `runbook`
Operational "how to" for predictable actions.
Use for step-by-step procedures: deploys, incident response, rollbacks, debugging checklists, common fixes, and operational ownership.

### `reference`
Declarative source of truth describing "how things are" (or the shared model).
Use for project vision, design system definitions, glossaries, conventions, domain models, stable APIs/contracts summaries, and other canonical descriptions meant for repeated lookup.

## Examples
```yaml
---
id: customer-interviews
type: note
purpose: "Capture insights from the latest customer interviews."
tags: ["research"]
related: ["research/landscape.md"]
---
```

```yaml
---
id: billing-retries
type: spec
purpose: "Define the retry policy for failed billing runs."
scope: ["payments", "scheduler"]
non_goals: ["UI changes"]
---
```
