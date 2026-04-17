---
description: How to add a standardized header comment to a file
---

# File Header Documentation Workflow

Follow these steps to add a standardized header comment to any file in the project.

## 1. Documentation Rules
Refer to the **Core Documentation Rules**: [Documentation Standards](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_documentation.md)

## 2. Header Format
```dart
/// --------------------------------------------------
/// ðŸ”¥ Feature: [Feature Name]
/// ðŸ‘¤ Author: Rakitic
/// ðŸ“… Date: [Current Date YYYY-MM-DD]
/// ðŸ“ Description:
///   [Brief description of the file's purpose]
/// --------------------------------------------------
```

## 3. Workflow Steps
1.  Identify the **Feature Name** (e.g., Login, Payroll, Attendance).
2.  Identify the **Description** of what the file does.
3.  Add the header **below any `import`, `part`, or `part of` statements**. If the file has no such statements, add it at the very top.
4.  Use the `multi_replace_file_content` tool to insert the header appropriately (below any `import`, `part`, or `part of` declarations).

