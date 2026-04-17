# Clean Architecture & SOLID Standards

This document defines the architectural patterns and principles for the my_stamp_collection project, ensuring a maintainable and scalable codebase.

## 1. SOLID Principles

- **Single Responsibility (S)**:
  - **Domain Entities**: Only hold data and basic logic for those entities.
  - **Usecases**: Handle a single business action.
  - **Blocs/Cubits**: Manage state transitions for a specific view. No business logic here (delegate to Usecases).
  - **Repositories**: Handle data fetching and Model-Entity transformation.
  - **Views/Widgets**: Pure UI rendering and event triggering.
- **Open/Closed (O)**: Favor composition over inheritance.
- **Dependency Inversion (D)**: Always depend on abstractions.
  - Use `get_it` for dependency injection.
  - Register in module-specific DI files (e.g., `lib/app/dependency_injection/modules/hrm/hrm_di.dart`).

## 2. Architectural Layers

- **Domain**: Pure Dart logic. NO Flutter dependencies. Contains Entities, Usecase interfaces, and Repository interfaces.
- **Data**: Implementation of repositories, data sources, model conversions, and external service integrations.
- **Presentation**: Blocs, Cubits, States, Pages, and Widgets.

## 3. Dependency Injection (Getti)

- **Initialization**: Use `getIt.registerLazyIfAbsent` to prevent duplicate registrations during hot restarts.
- **Consumption**: Blocs/Cubits should be instantiated in the View via `BlocProvider`, with Usecases injected from `getIt`.

## 4. Module Structure

- Each feature (e.g., `hrm`, `kpi`) must be self-contained in its own module folder.
- Follow the sub-directory pattern: `domain/`, `data/`, `presentation/`.

---

> [!NOTE]
> All new features MUST be scaffolded using these layers. Bypassing the Domain layer for "simpler" tasks is not permitted.

