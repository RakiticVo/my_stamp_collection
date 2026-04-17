# UI & UX Standard Tokens

This document defines the unified UI tokens and design standards for the my_stamp_collection project. Adhering to these tokens ensures visual consistency across all modules.

## 1. Zero-Literal Rule

- **Rule**: NEVER use literal values (hex colors, pixel sizes, specific fonts) directly in widgets.
- **Exception**: Only allowed in the core theme definition files.

## 2. Layout & Scaling

- **Scaling**: Use `AppLayout` for all dimension scaling to ensure responsive behavior across device sizes.
  - Width: `AppLayout.w(size: ...)`
  - Height: `AppLayout.h(size: ...)`
  - Font Size: `AppLayout.s(size: ...)`
- **Spacing**: Use `AppSizedBox` for consistent gaps.
  - `AppSizedBox.w(size: ...)`
  - `AppSizedBox.h(size: ...)`

## 3. Typography

- **Standards**: Always use `AppTextStyle` tokens.
- **Example Usage**: `AppTextStyle.s18w5`, `AppTextStyle.s16R`.
- **Customization**: If a specific font size/weight is required that isn't tokenized, use `AppTextStyle.custom(...)`.

## 4. Colors

- **Standards**: Always use `AppColors` fields.
- **Common Tokens**:
  - `AppColors.mainDarkGreen` (Primary)
  - `AppColors.lightOrange` (Highlights)
  - `AppColors.mainGrey` (Text/Borders)

## 5. Insets & Borders

- **Standards**: Always use `AppEdgeInsets` for padding/margin and `AppBorderRadius` or `AppShape` for corners.
- **Example**: `padding: AppEdgeInsets.all(value: 8.0)`, `shape: AppShape.roundedRect8`.

## 6. Standard Components

- **Rule**: Use the project's library of custom widgets instead of standard Flutter SDK widgets where available.
- **Buttons**: `TextButtonCustom`, `IconButtonCustom`.
- **Loading**: `LoadingCustom`.
- **AppBar**: `AppbarBasicCustom`.
- **Watermark**: `WatermarkCustom`.

---

> [!CAUTION]
> Using hardcoded values (e.g., `Color(0xFF...)` or `padding: EdgeInsets.all(10)`) is a major violation and will cause UI inconsistency on different screen densities.
