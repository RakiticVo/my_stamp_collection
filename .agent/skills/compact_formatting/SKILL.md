# Compact Formatting Skill (Rakitic Style)

This skill describes how to manually format Dart code to match the "Compact/Horizontal" preference of the project, overriding standard automatic formatting behaviors.

## Core Objective
Keep code dense. Avoid excessive vertical growth caused by trailing commas.

## Techniques

### 1. The Single Argument Wrap
Avoid splitting a single argument into multiple lines if it can fit on one.
- **Avoid**:
  ```dart
  someFunction(
    argument: value,
  );
  ```
- **Prefer**:
  ```dart
  someFunction(argument: value);
  ```

### 2. Nested Call Horizontalization
When a function call is nested as an argument, keep the opening parenthesis of the inner call on the same line as the outer call.
- **Rakitic Style**:
  ```dart
  futures.add(businessUseCase.getBusinessTicketList(
    context: context,
    monthStr: monthYear,
  ));
  ```

### 3. Collection Compactness
When initializing small lists or maps, keep them on one line.
- **Prefer**: `final months = ['04/2026', '03/2026'];`
- **Avoid**:
  ```dart
  final months = [
    '04/2026',
    '03/2026',
  ];
  ```

### 4. Trailing Comma Rule
- **Use** a trailing comma only for:
  - Very long argument lists (4+ items).
  - When the arguments themselves are complex multi-line blocks (like nested widgets).
- **Omit** a trailing comma for:
  - Simple utility calls.
  - One-shot API calls with few parameters.
  - Builders that are short.

## Line Length Limit
The project allows up to **140 characters** before a mandatory break.

## Interaction with IDE
If the IDE's auto-formatter insists on splitting lines, try removing the trailing comma and manually formatting before saving.
