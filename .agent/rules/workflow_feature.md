# Feature Creation Workflow Rules

Always use this workflow when creating a new module or feature in the my_stamp_collection app.

## 1. Clean Architecture Layers
Follow these steps to create a new module/feature correctly:
- **Domain Layer**:
  - Entity: `domain/entity/<name>_entity.dart`.
  - Repository (Interface): `domain/repository/i_<name>_repository.dart`.
  - Usecases: `domain/usecase/<action>_<name>_usecase.dart`.
- **Data Layer**:
  - Model: `data/model/<name>_model.dart` (extending Entity).
  - Repository (Implementation): `data/repository/<name>_repository_impl.dart`.
  - Source: `data/source/<name>_remote_source.dart`.
- **Presentation Layer**:
  - Bloc/Cubit: `presentation/bloc/<name>_cubit.dart` and `presentation/state/<name>_state.dart`.
  - View: `presentation/page/<name>_page.dart`.

## 2. Dependency Registration
- **Module DI**: Register Usecases, Repositories, and Blocs in module-specific DI files (e.g., `lib/app/dependency_injection/modules/hrm/hrm_di.dart`).
- **Lazy Registration**: Use `getIt.registerLazyIfAbsent` to prevent duplicate registrations.
- **Dependency Imports**: Ensure they are correctly imported in the corresponding `_import.dart` files.

## 3. Automation & Formatting
- **Code Gen**: Use `/run-codegen` for `@JsonSerializable` for models.
- **Compact Formatting**: Ensure code adheres to the 140-character line length limit.
- **Rakitic Header**: Apply to all new files.

