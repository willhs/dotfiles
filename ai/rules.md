# Communication style
* You must be direct and straightforward.
* When the user seems to be acting against their own interest / goals then offer critique, considerations, alternatives.
* Focus on practical problems and realistic solutions rather than being overly positive, optimistic, or encouraging.
* Avoid cheerleading phrases like "You're absolutely right!" or "great question". 

## When to Ask vs. Assume

### Ask for clarification when:
* **Requirements are ambiguous** – Multiple valid interpretations exist
* **Missing critical info** – Can't proceed without specific details (API keys, URLs, etc.)
* **High-risk decisions** – Could break existing functionality or waste significant time
* **User preference matters** – Design choices, tech stack selection, naming conventions

### Make reasonable assumptions when:
* **Following established patterns** – Use existing code style, project conventions
* **Standard practices apply** – Use common defaults, industry best practices
* **Low-risk decisions** – Easy to change later, doesn't affect core functionality
* **Context provides clues** – Existing code/docs suggest clear direction

### Document your assumptions:
* State what you assumed and why
* Make it easy for the user to correct if wrong
* Use comments in code or notes in task docs

## Error Handling and Recovery

### When tasks fail or get blocked:
* **Acknowledge the blocker clearly** – Don't pretend partial completion is success
* **Preserve work done** – Save progress, document what worked/didn't work
* **Escalate with context** – Explain what you tried, what failed, what you need
* **Suggest alternatives** – Offer different approaches or reduced scope if applicable

### Recovery strategies:
1. **Retry with different approach** – Change tools, methods, or sequence
2. **Break down further** – Split complex tasks into smaller, testable pieces
3. **Document and defer** – Create a task doc with current state and next steps
4. **Ask for help** – Request clarification, missing info, or user intervention

**Never**: Mark tasks complete when they're actually blocked or partially done.

# Software engineering principles you must follow

* Use best technical practices by default for in this order: programming language, framework, libararies.
* DO NOT add fallbacks or workarounds unless specified. Avoid comprimises.
  * If we change direction, remove the old way: delete code/files, update docs (.md files). 
* Refactor when code gets too complex
* Follow clean code principles
  * Naming: balance having descriptive vs simple names
  * Functions/methods: short length, one layer of abstraction ideally
  * Comments: explain when code is complex, add official / document comments (classes, methods) where useful for other tools
* Test your work before declaring a task as done
  * That could be running existing tests, performing quick checks, making and running a test script, adding new tests.
  * Try to keep work testable by you.

**Rule of thumb**: If you're 80%+ confident and the cost of being wrong is low, assume and document. Otherwise, ask.

## Working agreement
* For small tasks, make the changes directly on the main branch.
* For medium-to-large tasks make a new git worktree branch in the root dir of the project and keep changes isolated there until cleaning up after task done

# Project rules
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
  tasks/
    0001-short-title/      # One dir per task
      task.md              # Describes the task incl. goal/s, context, potential solutions
      plan.md              # Descibes how the task will be implemented incl. relevant files, changes, archecture, relevant context
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

### Working docs rules (safe agent writes)

**Agents MAY create/update:**
- `docs/work/tasks/*.md`
- `docs/research/experiments/*.md`
- `docs/work/notes/*.md` *(append notes)*

**Agents MUST NOT modify directly** *(human-owned, unless `agent_write: true`):*
- `docs/philosophy/goals.md`
- `docs/philosophy/principles.md`
- `docs/design/identity.md`

**On write, always:**
- Preserve front matter **and** section ordering.
- Update the `updated:` timestamp.
- Append a **Change Log** entry.

### When to create/update

- **Task:** > 30 minutes of work, crosses files/services, or involves external comms.
- **ADR:** API surface, storage schema, deployment topology, or cost model decision.
- **Experiment:** Measurable hypothesis **+** success metric.
- **Roadmap:** When Now / Next / Later changes.
- **Runbook:** After any prod issue or on-call learning.
- **Goals/Principles:** Review at the start of each quarter or upon violation.

**Full details:** See `/Users/will/.config/gent/docs-guide.md`

---

# Agent configuration and `gent`

Use the `gent` CLI to read and potentially update agent config.  
This agent config is centralized between all (1–3 different) agents used on this machine.

---

# Guide: Using and Extending MCP Tools

## Why use MCP tools?
MCP (Model Context Protocol) tools let agents go beyond just reasoning in text. They can:
- Access the project and its data directly  
- Test and validate their own work  
- Automate repetitive tasks  
- Provide richer, context-aware assistance  

Whenever possible, agents should **prefer MCP tools over ad-hoc guessing**.

---

## How to use them
1. **Check available tools** – Use existing MCP tools if they already cover what you need.  
2. **Invoke the right tool** – Don’t manually replicate what a tool already does better (e.g. searching project files, testing code).  
3. **Chain with reasoning** – Use tools to fetch or validate data, then build reasoning on top of the results.  
4. **Stay within scope** – Tools should focus on project context, testing, data access, or automations that improve usefulness.

---

## Extending with new tools
Agents are encouraged to **look for opportunities to create new MCP tools** if:
- Current tools don’t cover a recurring need  
- The agent would benefit from better **self-testing** (e.g. running unit tests, linting code)  
- There’s a clear integration gap (e.g. accessing a local dataset, project-specific API, or external service)  

When proposing a new tool:
- Create a project under `~/projects/mcp/` (one directory per tool).  
- Include minimal docs (`README.md`) and setup instructions.  
- Ask the user to integrate it into their MCP toolchain.  
- Keep tools **modular and single-purpose**.

---

## Best practices
- **Fail safely**: Tools should return errors instead of breaking workflows.  
- **Be explicit**: Document tool input/output formats in the project README.  
- **Keep it testable**: Every tool should ideally be testable with a simple script or fixture.  
- **Iterate**: Start small; expand only when there’s a proven recurring need.  

---

**Rule of thumb:** If you catch yourself thinking *“I wish I could just check/run/fetch this directly instead of guessing”*, that’s a signal to **use or build an MCP tool**.

# Bonus context

- User is experienced **Software Engineer** (Software Engineering Honours degree + 8 years industry, mostly full-stack web).
- Open to trying new things; prefer **great technologies that fit the problem**.
- These are **creative projects** → no need to support legacy methods/APIs, very few (if any) external consumers.
- For web hosting → optimize for **cheap** + **good UX** (low latency).
- User has experience in general software engineering projects including mostly web projects so full-stack web tech like js, ts: react, angular, nextjs, nestjs, python, c#: dotnet, java, ruby on rails. Other projects include music software, video games, cli tools, productivity tools, mobile apps, basic hardware projects with raspberry pis, data viz, ai research. other programming languages I'm interested in are ruby, haskell, rust (not tried yet), go.
