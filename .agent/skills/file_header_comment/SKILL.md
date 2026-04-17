# Skill: File Header Comment Generation

Automatically generate standardized file header comments for core logic files (Usecases, Repositories, Blocs, Cubits) to improve documentation and traceability.

> [!IMPORTANT]
> This skill is governed by the project's [Documentation & Header Standards](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_documentation.md). Refer to this standard for the correct template and placement rules.

## Rules
- Use this skill whenever creating a new core logic file or updating an important existing one.
- The header MUST be placed **below any `import`, `part`, or `part of` statements**. If the file has no such statements, the header MUST be placed at the very top.
- The default author is `Rakitic` unless specified otherwise.
- The date should be the current date in `YYYY-MM-DD` format.
- **Generated Files**: Skip all files ending in `.g.dart` or `.freezed.dart`.

## Template
```dart
/// --------------------------------------------------
/// 🔥 Feature: {{feature_name}}
/// 👤 Author: {{author_name}}
/// 📅 Date: {{current_date}}
/// 📝 Description:
///   {{description}}
/// --------------------------------------------------
```

## Usage Example
When asked to add a header for a `LoginUseCase`:
```dart
/// --------------------------------------------------
/// 🔥 Feature: User Authentication
/// 👤 Author: Rakitic
/// 📅 Date: 2026-03-18
/// 📝 Description:
///   Handles the login logic and token management.
/// --------------------------------------------------
```

## Audit Logic
When performing an audit of file headers in a specific folder, follow these evaluation criteria:

### 1. Header Presence
- **Missing**: Any `.dart` file that does not contain the `/// --------------------------------------------------` block is considered missing a header.

### 2. Header Placement
- **Incorrect**: The header is sitting at the very top (Line 1) but is followed by `import`, `part`, or `part of` statements.
- **Correct**: The header is placed immediately below the last `import`, `part`, or `part of` statement, separated by a blank line.
- **Exception**: If there are NO imports or parts, the header SHOULD be at the top (Line 1).

### 3. Header Format
- **Malformed**: The header exists but misses the `Author: Rakitic` field or has an invalid `Date` format.
- **Placeholder**: The header contains template placeholders like `{{feature_name}}` or `[Brief description]`.

### 4. Remediation
- **If Missing**: Generate a new header using the template above.
- **If Misplaced**: Extract the existing header and move it to the correct position (below imports).
- **If Malformed**: Update the fields to match the standardized format while preserving the actual content.

## Automated Batch Processing
For modules with many files (e.g., >10 files), use a **Dart-based automation script** instead of manual editing.
- **Dart Priority**: Follow the [dart-automation.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/dart-automation.md) rule.
- **Encoding**: Scripts MUST use `utf8` encoding for both read and write operations to preserve Vietnamese comments and emojis.
- **Safety**: Always perform a diagnostic scan before running an injection script to ensure no duplicates or corruption.
