# Rule: Header Audit & Standardization

This rule enforces the mandatory process for auditing and fixing file headers to ensure compliance with the Rakitic-style documentation standards.

## 1. Scope Constraint
- **MANDATORY**: You MUST specify a single target folder (e.g., `lib/modules/erp`) before starting an audit. 
- **FORBIDDEN**: Project-wide automatic header fixes are strictly prohibited to prevent massive, unverified changes.
- **EXCLUSION**: Automatically generated files (e.g., `*.g.dart`, `*.freezed.dart`) are EXEMPT from all header requirements.
- **REMOVAL REQUIRED**: If an audit finds manual Rakitic-style headers in generated files, those headers MUST be removed to keep generated files pristine.

## 2. Header Placement Rules
- **Rule A**: The header MUST be placed **below all `import`, `part`, or `part of` statements**.
- **Audit Exception**: You are granted permanent permission to run read-only diagnostic/scan scripts (e.g., PowerShell audits) for header compliance without asking for approval. However, NO code modifications can be made without an approved plan.
- **Rule B**: If the file has **no** such statements, the header MUST be placed at the very top (Line 1).
- **Rule C**: A blank line MUST separate the header from the preceding import block and the following code.

## 3. Planning & Approval
- Before applying any fixes, you MUST provide an **Implementation Plan** listing:
    1. Files missing headers.
    2. Files with misplaced headers.
    3. Files with malformed headers (wrong format).
- **THE HARD STOP**: You MUST wait for explicit user approval before running any `replace_file_content` or `multi_replace_file_content` tools on the target files.

## 4. Compliance
- [core.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/core.md)
- [SKILL.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/skills/file_header_comment/SKILL.md)
- [dart-automation.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/dart-automation.md)
