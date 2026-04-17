# Coding Logic & Best Practices

This document defines the logic and state management standards for the my_stamp_collection project. These rules ensure that code remains scalable, readable, and free from common "logic traps."

## 1. Enum over Boolean Rule

- **Rule**: ALWAYS prioritize using `enum` over `boolean` flags for any variable that represents a "state," "type," or "mode."
- **Rationale**:
  - **Scalability**: A variable that is a boolean today often needs a third or fourth state tomorrow. Enums handle this gracefully; booleans require complex transitions to multiple flags.
  - **Readability**: `type: ActionButtonType.primary` is much more self-documenting than `isPrimary: true`.
  - **Boolean Trap**: Avoid functions with multiple boolean parameters (e.g., `doWork(true, false, true)`), as their meaning is impossible to determine without checking the definition.

### Example

```dart
// BAD: Boolean flag
class ActionButton extends StatelessWidget {
  final bool isPrimary;
  // ...
}

// GOOD: Enum type
enum ActionButtonType { primary, secondary, outline }

class ActionButton extends StatelessWidget {
  final ActionButtonType type;
  // ...
}
```

## 2. Exhaustive Switches

- **Rule**: When branching logic based on an enum, always use a `switch` statement without a `default` clause where possible.
- **Rationale**: This allows the Dart compiler to provide a compile-time error if a new enum value is added but not handled in that specific logic path.

---

> [!IMPORTANT]
> This standard applies to all NEW code. Existing boolean flags should be refactored to enums when they are modified or expanded.
