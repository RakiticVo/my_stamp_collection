# my_stamp_collection - Core Coding Rules

These rules define the coding standards when interacting with the my_stamp_collection codebase.

## Rule 0: Planning & Approval First (MANDATORY) - THE HARD STOP
- **Research Phase**: For any task that is not "trivially simple," you MUST perform a thorough research phase first. Use ONLY read-only tools (`view_file`, `list_dir`, `grep_search`, `read_url_content`) to understand the codebase, dependencies, and implications.
- **Implementation Plan**: You MUST provide a detailed `implementation_plan.md` artifact after the research phase.
- **THE HARD STOP**: Immediately after presenting the plan, you MUST **STOP** and wait for explicit USER approval (e.g., "Yes", "Proceed", "Go ahead").
- **Execution Phase**: You are forbidden from running ANY modifying commands (e.g., `write_to_file`, `replace_file_content`, `run_command`, `git commit`) until after receiving explicit approval for the plan.
- **No Assumptions**: If any part of the request is ambiguous, ask the USER for clarification before planning.
- **Auto-Run Exemption**: As per user directive, you MAY auto-run (using `SafeToAutoRun: true`) commands that do not modify source code or state, specifically `flutter analyze` and `flutter test`.

- **Trivially Simple Exception**: This rule only applies to non-trivial tasks. Simple tasks like fixing typos, adding comments, or minor UI literal changes do not require a formal plan but still require a brief explanation before execution.

## 1. Technical Standards (Styles) - MANDATORY
All code development and design must adhere to the modular style standards defined in the `.agent/styles/` directory:

- **[Formatting & Density](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_formatting.md)**: Standards for compact UI, nesting, and formatting.
- **[Naming Conventions](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_naming.md)**: Rules for classes, files, git branches, and commits.
- **[UI & UX Tokens](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_ui_ux.md)**: Standards for colors, scaling (`AppLayout`), and widgets.
- **[Architecture & SOLID](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_architecture.md)**: Standards for project layers, SOLID, and DI.
- **[Documentation](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_documentation.md)**: Standards for file headers and version history.

---

## 2. System File Protection & Workspace Boundaries
- **Safe Folders**: The primary operational scope is limited strictly to `lib/`, `test/`, and `assets/`. These are the designated safe zones for code and resource modifications.
- **System File Identification**: Any file not contained within the safe folders (e.g., `android/`, `ios/`, `pubspec.yaml`, `build.gradle`, internal hidden folders like `.idea/`) is classified as a **System File**.
- **RESTRICTION**: Minimize touching or altering any System Files whenever possible.
- **APPROVAL REQUIRED**: Before reading, editing, or making any changes to a System File, you **MUST** first outline the required changes and ask for EXPLICIT permission from the USER.
- **High Caution**: When granted permission to work outside the Safe Folders, operate with extreme caution and precision to prevent catastrophic build failures or configurations issues.

## 9. Temporary File Cleanup
- **Rule**: If you generate any temporary files, scratch scripts, or intermediate logs during a task (e.g., `audit_results.txt`, `temp_script.sh`), you MUST delete them once the task is complete or before submitting your final response. 
- **Exception**: Only persist files that provide long-term value to the project or were explicitly requested by the USER to be kept.

## 10. Session Branch Check (MANDATORY â€” START OF EVERY CONVERSATION)
- **Rule**: In your **FIRST response** of every new conversation, BEFORE doing anything else, you MUST ask the user the following:
  > *"ðŸŒ¿ Would you like to create a new branch to work on in this session? (Yes / No)"*
- **If "Yes"**: Immediately invoke the `create_branch` skill to guide the user in creating a branch according to project standards.
- **If "No"**: Continue working on the current branch. Run `git branch --show-current` and inform the user which branch you are working on.
- **Exception**: If the user has explicitly described the branch in their first prompt (e.g., *"I am on the feature/xxx branch, help me..."*), you may skip this question.
- **Branch Rules**: Refer to [workflow_branch.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/workflow_branch.md) for naming standards and policy.

