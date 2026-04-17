# Rule: Automation & Bypass Permissions

This rule documents the explicit permissions granted by the user to bypass manual approval for specific non-modifying commands.

## 1. Authorized Commands
The following commands have been designated as **Safe to Auto-Run** because they perform analysis or verification without modifying the source code, state, or structure of the project:

- `flutter analyze`
- `flutter test`

## 2. Usage Policy
- **Permission**: When executing these specific commands, the agent SHOULD set `SafeToAutoRun: true` in the `run_command` tool.
- **Reporting**: The results of these commands (especially failure states) MUST still be reported to the user as part of the task summary.
- **Scope Restriction**: This permission applies ONLY to the exact branch of the command. For example, `flutter analyze` is allowed, but `flutter analyze --fix` (which modifies code) is NOT allowed without explicit approval.

## 3. Revocation
- This permission can be revoked by the user at any time by requesting the removal of this rule or by updating the `core.md` standards.

---
*Authorized by user directive on 2026-04-17.*
