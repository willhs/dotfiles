---
argument-hint: [aspect-to-iterate]
description: iterate on an aspect of the project
---

Let's do an iteration on this aspect of the current project: $ARGUMENTS.

Do these in order:
- Understand the project and its goals by reading @README.md and @docs
- Examine the current iteration of that aspect or thing about the project until you understand it
- Pick a few ways the project could be most improved by given the project goals and any guidance in the arugments, and software engineering principles.
- Create a new git worktree in the project root and navigate to it.
- Implement them as needed
- Test to verify the changes are as you intended like with e2e testing (e.g. with playwright tool if the change is on testable on a web front end), or unit testing. whaever is appropriate for you to feel confident
- When confident change works and code cleaned up: merge branch into main and remove worktree
