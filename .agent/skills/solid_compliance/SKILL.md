# Skill: SOLID Principles Check
---
name: solid_compliance
description: Check code compliance with SOLID principles in the my_stamp_collection codebase.
---

Use this skill when you're reviewing a new piece of logic, a class, or a repository.

> [!IMPORTANT]
> This skill is governed by the project's [Clean Architecture & SOLID Standards](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_architecture.md). Ensure any violations found are cross-referenced with this standard.

### Instructions
1.  **Check Single Responsibility (S)**:
    - Does this class have more than one reason to change?
    - Is a Bloc handling business logic calculations? (If so, move to a Usecase).
    - Is a Repository handling UI transformations? (If so, move to a Model or View).
2.  **Check Open/Closed (O)**:
    - Is the code using inheritance when composition would be better?
    - Can this function be extended without modifying its core code?
3.  **Check Liskov Substitution (L)**:
    - Is this subclass or implementation breaking any contracts of the parent interface?
4.  **Check Interface Segregation (I)**:
    - Are the Repository interfaces too fat?
    - Split large interfaces into smaller ones for specific modules.
5.  **Check Dependency Inversion (D)**:
    - Does the class depend on a concrete implementation?
    - Is it using DI (Constructor Injection) properly?
    - Does the class depend on an abstraction?

### Benchmarks (Official Guides)
- [Robert C. Martin (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Official Flutter State Management (Bloc)](https://bloclibrary.dev/architecture/)
- [Dependency Injection with GetIt](https://pub.dev/packages/get_it)
