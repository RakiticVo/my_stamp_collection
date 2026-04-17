# Documentation & File Header Standards

This document defines the documentation standards for the my_stamp_collection project, ensuring every file and change is traceable and human-readable.

## 1. Standardized File Headers

- **Requirement**: ALL new code files MUST include a standardized header below all `import`, `part`, or `part of` statements.
- **Exclusion**: Generated files (`*.g.dart`, `*.freezed.dart`) are exempt.
- **Header Format**:
  ```dart
  /// --------------------------------------------------
  /// ðŸ”¥ Feature: <Feature Name>
  /// ðŸ‘¤ Author: <Name>
  /// ðŸ“… Date: <YYYY-MM-DD>
  /// ðŸ“ Description:
  ///   <Brief and clear description of the file's purpose>
  /// --------------------------------------------------
  ```
- **Author**: Use a consistent team identifier (e.g., `Project Team`) as the author name.

## 2. README & History Version

- **Requirement**: Every functional change must be logged in the `README.md` `### History Version` section.
- **Tone**: Must be user-oriented and functional. Avoid technical jargon (e.g., instead of "Refactored Bloc structure", use "Improved performance of the KPI data loading").
- **ID Requirement**: Always include the feature/ticket ID if available (e.g., `feature/#1`).

## 3. Code Comments

- **Class/Method Documentation**: Use `///` (triple slash) for documenting public classes and methods.
- **Internal Logic**: Use `//` for brief internal implementation details.
- **Maintenance**: Update outdated comments immediately when logic changes.

---

> [!IMPORTANT]
> Documentation is as critical as code. Files without headers will fail the project's internal audit.

