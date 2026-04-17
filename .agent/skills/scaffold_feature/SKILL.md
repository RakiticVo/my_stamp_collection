# Skill: Scaffold Clean Architecture Feature
---
name: scaffold_feature
description: Automatically create the directory structure for a new feature module following Clean Architecture.
---

Use this skill when you need to start a new feature or module in the my_stamp_collection app.

### Instructions
1.  **Identify the module path**: e.g., `lib/modules/hrm/new_feature`.
2.  **Create the Domain Layer**:
    - `domain/entity/`: The data classes.
    - `domain/repository/`: The abstract repository interface.
    - `domain/usecase/`: The specific logic classes.
3.  **Create the Data Layer**:
    - `data/model/`: Data Transfer Objects (DTOs) for JSON/GraphQL.
    - `data/repository/`: The implementation of the repository interface.
    - `data/source/`: Remote/Local data sources (using Dio or GraphQL).
4.  **Create the Presentation Layer**:
    - `presentation/bloc/`: The Bloc, Event, and State classes.
    - `presentation/page/`: The main widget for the feature.
    - `presentation/widget/`: Smaller, reusable components for this feature.
5.  **Clean Architecture Check**: Ensure that `domain` has no dependencies on `data`, `presentation`, or `flutter` (where possible).

### Example Structure:
```
lib/modules/hrm/user_info/basic_info/
├── data/
│   ├── model/
│   ├── repository/
│   └── source/
├── domain/
│   ├── entity/
│   ├── repository/
│   └── usecase/
└── presentation/
    ├── bloc/
    ├── page/
    └── widget/
```
