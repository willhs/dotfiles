---
description: Create a new task directory in docs/tasks/ with proper numbering and structure
argument-hint: [task-description]
---

# Create Task

You need to create a new task directory in docs/tasks/ with proper numbering and structured documentation.

## Initial Response

When this command is invoked:

1. **Check if task description was provided**:
   - If a task name was implied in the description, proceed with information gathering
   - If no clear cohesive task can be named, ask for user to confirm.

2. **Gather essential task information**:
   ```
   I'll help you create a new task. I need some basic information to generate a proper task file.

   1. Task name: [if not provided]
   2. What is the main goal or objective of this task? (1-2 sentences)
   3. Why is this task needed? What's the current situation or problem?
   4. Are there any specific requirements or constraints I should know about?
   5. Do you have any initial ideas for how to approach this?

   You can provide as much or as little detail as you want - I'll create a structured task file that can be expanded later.
   ```

3. **Continue prompting until you have at least**:
   - Task name (for directory naming)
   - Goal statement (what needs to be accomplished)
   - Context or problem statement (why it's needed)
   - At least one requirement or constraint

## Steps to Complete

1. **Find the project root and docs/tasks directory**:
   - Look for docs/ directory in current working directory or parent directories
   - Navigate to docs/tasks/ subdirectory

2. **Determine next task number**:
   - List existing task directories in docs/tasks/
   - Find the highest numbered task (e.g., 0001-, 0002-, etc.)
   - Calculate next sequential number with zero-padding (e.g., 0003)

3. **Create task directory structure**:
   - Create directory: `docs/tasks/NNNN-task-name/`
   - Where NNNN is the zero-padded task number
   - And task-name is derived from user input (convert to kebab-case)

4. **Generate task.md file**:
   - Create task.md in the new directory
   - Fill in the template with actual information gathered from user
   - Use placeholder text for sections not covered in the conversation

5. **Populate template intelligently**:
   - Replace [Task Title] with descriptive name based on user input
   - Fill Goal section with user's objective statement
   - Fill Context section with problem/situation description
   - Add any specific requirements mentioned to appropriate Must/Should/Could Have sections
   - If user mentioned approach ideas, add them to Potential Solutions
   - Leave template placeholders for sections not discussed

## Task Template

```markdown
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# [Task Title]

## Goal

[What needs to be accomplished - be specific and measurable]

## Context

[Background information, current state, and why this task is needed]

## Requirements

### Must Have
- [Essential requirement 1]
- [Essential requirement 2]

### Should Have
- [Important but not critical requirement 1]
- [Important but not critical requirement 2]

### Could Have
- [Nice to have requirement 1]
- [Nice to have requirement 2]

## Constraints

- [Technical constraint 1]
- [Business constraint 1]
- [Time/resource constraint 1]

## Potential Solutions

### Option 1: [Solution Name]
**Approach**: [Brief description]
**Pros**:
- [Advantage 1]
- [Advantage 2]
**Cons**:
- [Disadvantage 1]
- [Disadvantage 2]

### Option 2: [Solution Name]
**Approach**: [Brief description]
**Pros**:
- [Advantage 1]
- [Advantage 2]
**Cons**:
- [Disadvantage 1]
- [Disadvantage 2]

## Success Criteria

- [ ] [Measurable success criterion 1]
- [ ] [Measurable success criterion 2]
- [ ] [Measurable success criterion 3]

## References

- [Related task/ticket/doc 1]
- [Related task/ticket/doc 2]

---

## Change Log

- YYYY-MM-DD: Task created
```

## Usage Examples

```bash
/create-task refactor-user-auth
```
Creates: `docs/tasks/0001-refactor-user-auth/task.md`

```bash
/create-task implement-dark-mode
```
Creates: `docs/tasks/0002-implement-dark-mode/task.md`

## Implementation Notes

- If no task name is provided, prompt the user for one
- Use kebab-case for directory names (lowercase with hyphens)
- Set proper timestamps in the frontmatter
- Ensure the task.md file has proper structure for later plan generation
- Report the final path to the user
- Be persistent but friendly when gathering minimum required information
- Accept brief answers but probe for clarification if needed

## Example Interactions

### Scenario 1: Minimal Information
```
User: /create-task
Assistant: I'll help you create a new task. What would you like to call this task?

User: user auth refactor
Assistant: Great! Now I need a bit more information:

1. What is the main goal of this user auth refactor? (1-2 sentences)
2. Why is this refactor needed? What problems are you trying to solve?

User: We need to move from basic auth to JWT tokens. The current system is insecure and doesn't scale.
Assistant: Perfect! Any specific requirements or constraints I should know about?

User: Must maintain backward compatibility for existing API clients
Assistant: [Creates task file with this information]
```

### Scenario 2: User Provides Name
```
User: /create-task implement-dark-mode
Assistant: I'll help you create a task for implementing dark mode. Could you tell me:

1. What's the main goal for this dark mode implementation?
2. Why is dark mode needed right now?
3. Any specific requirements or constraints?

User: We want to add a dark mode toggle to the settings page because users have been requesting it. It should persist across sessions and apply to all components. Must work on both desktop and mobile.
Assistant: [Creates comprehensive task file with all details provided]
```

### Scenario 3: User Provides Task Details
```
User: /create-task basic API rate limiting. I want to create a free and paid tier where the free tier can only call the API. The tier is already saved against the user in the db. Limit free tier to 100 requests per day.
Assistant: I'll create a task for API rate limiting. 

[Continues gathering information...]
```
