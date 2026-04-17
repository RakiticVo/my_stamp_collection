# UI Responsiveness Standards

All UI components and pages in Stampzy MUST be built with responsiveness as a primary requirement. The application must provide a premium experience across Mobile, Tablet, and Desktop screen sizes.

## The Rule

> [!IMPORTANT]
> **Mandatory Responsive Utility**: Every UI-related file (Widgets, Pages, Layouters) MUST import and utilize the `Responsive` utility (defined in `lib/app/utils/responsive.dart`) to handle layout decisions, scaling, and adaptive spacing.

### ✅ Correct Usage

#### 1. Conditional Layouts
```dart
child: Responsive.isMobile(context)
    ? VerticalLayout()
    : HorizontalLayout(),
```

#### 2. Adaptive Spacing
```dart
padding: EdgeInsets.symmetric(
  horizontal: Responsive.isMobile(context) ? 24 : 48,
  vertical: 32,
),
```

#### 3. Dynamic Grid Counts
```dart
GridView.count(
  crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
  // ...
)
```

## Standard Breakpoints

- **Mobile**: Width < 600px
- **Tablet**: 600px <= Width < 1200px
- **Desktop**: Width >= 1200px

## Best Practices

1.  **Avoid Hardcoded Widths**: Never use hardcoded pixel widths for containers unless they are strictly constrained (e.g., icons, small avatars). Use `Expanded`, `Flexible`, or percentage-based widths via `MediaQuery`.
2.  **Constraint-Based Design**: Use `LayoutBuilder` within complex widgets to make them "self-aware" of their parent constraints.
3.  **Adaptive Typography**: Scale font sizes based on device type using `Responsive`.
