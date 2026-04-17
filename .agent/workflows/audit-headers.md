---
description: Iteratively audit and standardize file headers folder by folder.
---

# File Header Audit & Standardization Workflow

Follow these steps to audit and stabilize file headers in a specific directory.

## 1. Prerequisites
- Target folder must exist (e.g., `lib/modules/login`).
- Standardize against [SKILL.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/skills/file_header_comment/SKILL.md).

## 2. Workflow Steps

### Step 1: Target Identification
- **Mandatory**: Ask the user which folder they want to audit.
- Do NOT proceed without a confirmed directory path.

### Step 2: Automated Audit (Pre-Approved)  // turbo
- Once the folder is identified, you are PERMITTED to run diagnostic scripts immediately without additional approval to identify:
    - Files with **MISSING** headers.
    - Files with headers at the **TOP** despite having `import`/`part` statements.
    - Files with **MALFORMED** header content.
- This step is strictly for analysis and MUST NOT modify any source files.

### Step 3: Planning (MANDATORY)
- Create an `implementation_plan.md` summarizing the audit findings.
- Group files into "Missing", "Misplaced", and "Malformed" categories.
- **STOP** and wait for explicit user approval.

### Step 4: Execution
- Apply the fixes using `replace_file_content` or `multi_replace_file_content` for small sets.
- For large modules (>10 files), create and execute a **Dart automation script** to ensure UTF-8 safety and efficiency.
- Follow the [dart-automation.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/dart-automation.md) rule.
- Ensure headers are moved **below** all `import`, `part`, or `part of` declarations.

### Step 5: Verification
- Run a final scan to verify all headers are now in the correct position.
- Document any remaining edge cases.

## 3. Compliance
Ensure all actions comply with:
- [core.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/core.md)
- [header-audit.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/header-audit.md)
- [dart-automation.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/dart-automation.md)

