# Context & Planning Workflow Rules

Always use this workflow when receiving a new task or if a task is not "trivially simple."

## 1. Context & Planning Rules
- **Clarification First**: ALWAYS check if the USER's request has sufficient context. If any detail is ambiguous (e.g., which file to modify, which branch to use, what is the expected behavior), you MUST ask the USER for clarification BEFORE performing ANY action.
- **No Assumptions**: Never assume the USER wants a specific implementation if multiple options exist. Present the options and ask for their preference.
- **Proposed Plan**: You MUST provide a detailed breakdown of the exact steps you intend to take after context is clear.
- **Approval Checkpoint**: You MUST wait for explicit USER approval (e.g., "Yes", "Proceed", "Go ahead") AFTER presenting your plan and BEFORE starting the implementation or running any commands (except for read-only tools like `view_file` or `list_dir`).

## 2. Research & Documentation
- **Research Phase**: For complex tasks, use `view_file`, `list_dir`, `grep_search` to understand the current implementation.
- **Implementation Plan**: Create an `implementation_plan.md` artifact to present your design to the USER.
- **Task Tracking**: Create a `task.md` artifact to track progress during execution.
- **Walkthrough**: Create a `walkthrough.md` artifact to summarize changes and results.
