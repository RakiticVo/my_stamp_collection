# Compact Formatting Style Standards

This document defines the high-density, compact formatting standards for the my_stamp_collection project. These rules prioritize vertical space efficiency and concise logic over standard expanded Dart linting.

## 1. Ternary Operators

- **Compact Chains**: Simple ternary operations should be written with minimal line breaks.
- **Alignment**: Align `?` and `:` if the chain extends multiple lines, but avoid forcing a line break for simple conditions.
- **Example**:
  ```dart
  // GOOD (Compact)
  state.isLoading 
    ? LoadingWidget() 
    : state is Error ? ErrorPage() : SuccessWidget()
  
  // BAD (Expanded)
  state.isLoading 
      ? LoadingWidget() 
      : state is Error 
          ? ErrorPage() 
          : SuccessWidget()
  ```

## 2. Conditionals and Early Returns

- **Single-line Logic**: Use `if (condition) return ...;` on a single line for simple early returns or loading states.
- **Example**:
  ```dart
  if (state.isLoading) return const Center(child: CircularProgressIndicator());
  ```

## 3. Widget Parameter Formatting

- **Horizontal Density**: Related simple parameters (integers, booleans, short strings) should stay on the same line where readability allows.
- **Avoid Trailing Comma Overuse**: Do not use trailing commas in every parameter list, as this forces the automated formatter to expand the widget vertically.
- **Example**:
  ```dart
  // GOOD
  _buildFooter(label: state.rankingLabel, value: state.rankingValue),
  
  // BAD
  _buildFooter(
    label: state.rankingLabel,
    value: state.rankingValue,
  ),
  ```

## 4. Bloc and Providers

- **Minimal Nesting Indentation**: Keep `BlocBuilder` and `BlocProvider` structures as tight as possible. Do not add extra line breaks between the provider and its child if the logic is straightforward.

## 5. Mapping and Loops

- **Arrow Functions**: Use arrow functions `=>` for row mapping in `.map()` calls whenever possible to keep the widget tree compact.
- **Example**:
  ```dart
  ...state.rows.map((row) => _buildDataRow(label: row.label, val1: row.actual)),
  ```

---

> [!CRITICAL]
> **ANY** code changes made by the AI MUST prioritize these compact standards. Re-formatting existing code into multi-line "expanded" structures is strictly forbidden.
