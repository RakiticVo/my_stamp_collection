---
description: Create a new module/feature Following Clean Architecture.
---

# Feature Creation Workflow

Follow these steps to create a new module/feature correctly.

## 1. Feature Creation Rules
Refer to the **Core Coding Rules**: [core.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/core.md)
Refer to the **Feature Workflow Rules**: [workflow_feature.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/workflow_feature.md)

## 2. Module Setup
1.  **Define the module name and path**: e.g., `lib/modules/hrm/leave_request`.
2.  **Create the Domain Layer**:
    - [ ] Entity: `domain/entity/<name>_entity.dart`.
    - [ ] Repository: `domain/repository/i_<name>_repository.dart`.
    - [ ] Usecase: `domain/usecase/<action>_<name>_usecase.dart`.
3.  **Create the Data Layer**:
    - [ ] Model: `data/model/<name>_model.dart`.
    - [ ] Repository: `data/repository/<name>_repository_impl.dart`.
    - [ ] Source: `data/source/<name>_remote_source.dart`.
4.  **Create the Presentation Layer**:
    - [ ] Bloc: `presentation/bloc/<name>_cubit.dart`.
    - [ ] Page: `presentation/page/<name>_page.dart`.
5.  **Register Dependencies**:
    - [ ] Register in module-specific DI file.
    - [ ] Add to `_import.dart`.

## 3. Automation
- [ ] Run `/run-codegen` to handle `@JsonSerializable`.

## 4. Final Polish
- [ ] Ensure [Compact Formatting](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/core.md#6-compact-formatting-rakitic-style---critical) (140-char limit).
- [ ] Apply [Rakitic Header](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/core.md#5-documentation--headers).

