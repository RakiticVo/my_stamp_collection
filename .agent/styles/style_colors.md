# Color Management Standards

To maintain a consistent design system and enable easy theme updates, all color definitions MUST be centralized within the `AppColors` class.

## The Rule

> [!IMPORTANT]
> **No Inline Colors**: Do not use hardcoded hex values `Color(0xFF...)` or Flutter built-in colors (`Colors.white`, `Colors.black`, etc.) directly in the UI code. 

### ✅ Correct Usage
```dart
Container(
  color: AppColors.primary,
)

// Opacity via withValues (standard practice)
Text(
  'Label',
  style: TextStyle(
    color: AppColors.onSurface.withValues(alpha: 0.7),
  ),
)
```

### ❌ Prohibited Usage
```dart
Container(
  color: Color(0xFF2196F3), // DO NOT DO THIS
)

Text(
  'Label',
  style: TextStyle(
    color: Colors.white, // DO NOT DO THIS
  ),
)
```

## Maintenance of AppColors

1.  **Semantic Naming**: If a new color is needed, add it to `AppColors` with a semantic name that describes its function (e.g., `brandSuccess`, `warningBanner`) rather than its hue.
2.  **Base Tokens**: Common utilities like `transparent`, `black`, and `white` should be accessed through `AppColors.transparent`, `AppColors.black`, and `AppColors.white`.
3.  **Gradients**: Gradients should ideally be defined as `static const LinearGradient` patterns within `AppColors` or an associated `AppGradients` class.
