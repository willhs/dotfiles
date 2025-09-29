---
description: Do discovery work to make possible improvements to the project
argument-hint: [thing-to-discover]
---

Discover a new thing $ARGUMENTS in the conext of software product discovery: experimenting with some new improvement or offering to the product. The user should say what they want to discover.

First, understand the current state of things: the relevent aspects of the product. Read @README.md and @docs/* to understand the overall project and its goals.

When you understand the relevant aspects of the product, and the problem to solve, come up with a few ideas to solve the problem by improving or building new things into the product.

Explore those ideas, and then report back to the user and REQUIRE THEIR APPROVAL BEFORE MOVING FORWARD.

If you get approval to move forward to implement an idea/s: 
* make a new git worktree in the project root dir and navigate to it whlie you work on the idea. 
* implement the idea in the worktree/branch
* test it until you're confident it it works the tools available e.g. automated tests, playwright mcp tool. if you can't test ask the user to
* when confident implementation is working and high quality, merge into main and remove worktree
