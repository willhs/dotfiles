---
description: Conduct comprehensive codebase research by spawning parallel sub-agents
argument-hint: [research-question-or-task-file]
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase to answer user questions by spawning parallel sub-agents and synthesizing their findings.

## Initial Setup:

When this command is invoked, respond with:
```
I'm ready to research the codebase. Please provide either:
1. A research question or area of interest
2. A task file path (e.g., docs/task/0001-feature/task.md or docs/work/tasks/0001-feature.md)

I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's research query or task file path.

## Steps to follow after receiving the research query or task file:

1. **Read any directly mentioned files first:**
   - If the user provides a task file path, read it FULLY first
   - If the user mentions other specific files in docs/, read them FULLY first
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: Read these files yourself in the main context before spawning any sub-tasks
   - This ensures you have full context before decomposing the research

2. **Analyze and decompose the research question:**
   - Break down the user's query into composable research areas
   - Take time to ultrathink about the underlying patterns, connections, and architectural implications the user might be seeking
   - Identify specific components, patterns, or concepts to investigate
   - Create a research plan using TodoWrite to track all subtasks
   - Consider which directories, files, or architectural patterns are relevant

3. **Spawn parallel sub-agent tasks for comprehensive research:**
   - Create multiple Task agents to research different aspects concurrently

   The key is to use these agents intelligently:
   - Start with locator agents to find what exists
   - Then use analyzer agents on the most promising findings
   - Run multiple agents in parallel when they're searching for different things
   - Each agent knows its job - just tell it what you're looking for
   - Don't write detailed prompts about HOW to search - the agents already know

4. **Wait for all sub-agents to complete and synthesize findings:**
   - IMPORTANT: Wait for ALL sub-agent tasks to complete before proceeding
   - Compile all sub-agent results (both codebase and docs findings)
   - Prioritize live codebase findings as primary source of truth
   - Use docs/ findings as supplementary historical context
   - Connect findings across different components
   - Include specific file paths and line numbers for reference
   - Verify all docs/ paths are correct (e.g., docs/philosophy/vision.md not docs/vision.md)
   - Highlight patterns, connections, and architectural decisions
   - Answer the user's specific questions with concrete evidence

5. **Determine output location:**
   - If researching an existing task: Add research findings to the task file under a new ## Research section
   - If general research query: Create `docs/research/topics/YYYY-MM-DD-description.md`
     - Format: `YYYY-MM-DD-description.md` where:
       - YYYY-MM-DD is today's date
       - description is a brief kebab-case description of the research topic
     - Example: `2025-01-08-improve-web-app-performance.md`

6. **Generate research content:**
   - **For existing tasks:** Add to the task file:
     ```markdown
     ## Research

     ### Research Question
     [What was researched about this task]

     ### Summary
     [High-level findings relevant to the task]

     ### Detailed Findings

     #### [Component/Area 1]
     - Finding with reference ([file.ext:line](link))
     - Connection to other components
     - Implementation details

     ### Code References
     - `path/to/file.py:123` - Description of what's there
     - `another/file.ts:45-67` - Description of the code block

     ### Architecture Insights
     [Patterns, conventions, and design decisions discovered]

     ### Related Tasks
     [Links to other task documents in docs/task/ or docs/work/tasks/]

     ### Open Questions
     [Any areas that need further investigation]
     ```

   - **For general research:** Create new document with YAML frontmatter:
     ```markdown
     ---
     topic: "[User's Question/Topic]"
     status: draft
     ---

     # Research: [User's Question/Topic]

     ## Research Question
     [Original user query]

     ## Summary
     [High-level findings answering the user's question]

     ## Detailed Findings

     ### [Component/Area 1]
     - Finding with reference ([file.ext:line](link))
     - Connection to other components
     - Implementation details

     ## Code References
     - `path/to/file.py:123` - Description of what's there
     - `another/file.ts:45-67` - Description of the code block

     ## Architecture Insights
     [Patterns, conventions, and design decisions discovered]

     ## Historical Context (from docs/)
     [Relevant insights from docs/ directory with references]
     - `docs/design/adr/0001-something.md` - Historical decision about X
     - `docs/research/topics/2025-08-02-web-app-performance.md` - Past exploration of Y
     - `docs/work/tasks/0001-improve-web-app-performance.md` - Past or present work on Z

     ## Related Research
     [Links to other research documents in docs/research/topics/]

     ## Open Questions
     [Any areas that need further investigation]
     ```

7. **Add GitHub permalinks (if applicable):**
   - Check if on main branch or if commit is pushed: `git branch --show-current` and `git status`
   - If on main/master or pushed, generate GitHub permalinks:
     - Get repo info: `gh repo view --json owner,name`
     - Create permalinks: `https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}`
   - Replace local file references with permalinks in the document

8. **Sync and present findings:**
   - Present a concise summary of findings to the user
   - Include key file references for easy navigation
   - Ask if they have follow-up questions or need clarification

9. **Handle follow-up questions:**
   - If the user has follow-up questions, append to the same research document
   - Add a new section: `## Follow-up Research [timestamp]`
   - Spawn new sub-agents as needed for additional investigation
   - Continue updating the document

## Important notes:
- Always use parallel Task agents to maximize efficiency and minimize context usage
- Always run fresh codebase research - never rely solely on existing research documents
- The docs/ directory provides historical context to supplement live findings
- Focus on finding concrete file paths and line numbers for developer reference
- Research documents should be self-contained with all necessary context
- Each sub-agent prompt should be specific and focused on read-only operations
- Consider cross-component connections and architectural patterns
- Include temporal context (when the research was conducted)
- Keep the main agent focused on synthesis, not deep file reading
- Encourage sub-agents to find examples and usage patterns, not just definitions
- Explore all of docs/ directory, not just research subdirectory
- **File reading**: Always read mentioned files FULLY (no limit/offset) before spawning sub-tasks
- **Critical ordering**: Follow the numbered steps exactly
  - ALWAYS read mentioned files first before spawning sub-tasks (step 1)
  - ALWAYS wait for all sub-agents to complete before synthesizing (step 4)
  - ALWAYS gather metadata before writing the document (step 5 before step 6)
  - NEVER write the research document with placeholder values
- **Document consistency**:
  - For new research documents, include frontmatter at the beginning
  - For task research, add to existing task structure
  - Keep research findings focused and actionable
