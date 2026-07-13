---
id: index
type: reference
purpose: "LLM-maintained navigable summary of all docs/ — read this first before any significant work."
scope: ["docs"]
non_goals: []
tags: ["index", "docs"]
related: ["front-matter.md", "front-matter-schema.json"]
---

# docs/ Index

> **Agents**: Read this file before starting any significant work. It tells you what exists and where to look. Open individual docs only when you need their full content.

## Philosophy

- [`philosophy/vision.md`](philosophy/vision.md) — North star: repeatable, minimal machine setup across macOS, Ubuntu, and WSL.
- [`philosophy/principles.md`](philosophy/principles.md) — Guiding principles for what belongs in dotfiles and how it should behave.

## Design

- [`design/architecture.md`](design/architecture.md) — Topic-centric layout, symlink conventions, zsh loading order, bootstrap flow, and profiles.
- [`design/adr/`](design/adr/) — Architecture Decision Records; each captures context, options, the choice made, and consequences.

## Work

- [`work/roadmap.md`](work/roadmap.md) — Now/Next/Later priorities, seeded from the 2026-07 security and completeness audit.

## Operations

- [`ops/runbook.md`](ops/runbook.md) — How to bootstrap a machine, re-run installers, add a topic, and recover from common breakage.

## Meta

- [`front-matter.md`](front-matter.md) — Human-readable guide to the frontmatter schema and doc types.
- [`front-matter-schema.json`](front-matter-schema.json) — JSON Schema for validating doc frontmatter.
- [`meta/templates/`](meta/templates/) — Starter templates for ADRs, tasks, plans, research, and experiments.
- [`log.md`](log.md) — Chronological log of changes to the docs/ knowledge base.
