# Naming Convention Standards

This document defines the naming standards for all components of the my_stamp_collection project, including code artifacts, files, and git-related metadata.

## 1. Code Class Naming

- **Entities**: Use `Entity` suffix (e.g., `UserEntity`).
- **Models**: Use `Model` suffix (e.g., `UserModel`). Models should generally extend or implement their corresponding Entity.
- **Usecases**: Use a verb-first name with `Usecase` suffix (e.g., `GetUserInfoUsecase`).
- **Repositories**: 
  - Interfaces (Domain): Prefix with `I` (e.g., `IUserRepository`).
  - Implementations (Data): Suffix with `Impl` (e.g., `UserRepositoryImpl`).
- **Blocs/Cubits**: 
  - Blocs: Use `Bloc`, `Event`, `State` suffixes.
  - Cubits: Use `Cubit`, `State` suffixes.
- **Views/Widgets**: 
  - Full pages: Suffix with `Page` (e.g., `KpiPage`).
  - Partial views: Suffix with `View` (e.g., `KpiSummaryView`).
  - Reusable components: Suffix with `Widget` or `Custom` (e.g., `AppbarBasicCustom`).

## 2. File Naming

- **Dart Files**: Always use `snake_case` (e.g., `kpi_summary_table.dart`).
- **Assets**: Use `snake_case` for all image and resource files.

## 3. Git Standards

### Branch Naming
- **Format**: `<type>/#<ticket-id>-<description>`
- **Types**: `feature`, `bugfix`, `hotfix`, `release`, `refactor`.
- **Special Rule (Release)**: If type is `release`, description is automatically `update-version`. Example: `release/#246-update-version`.

### Commit Message Naming
- **Format**: `dd/mm/yyyy: <type>(<scope>): <subject>`
- **Scope**: Must specify the affected feature (e.g., `kpi`, `hrm`, `auth`).
- **Subject**: Must be user-oriented and describe functional changes, not technical details.
- **Example**: `14/04/2026: feat(kpi): update summary table row layout for better readability`

---

> [!IMPORTANT]
> Consistency in naming is crucial for automated discovery and maintenance. Deviating from these standards will trigger a lint warning.
