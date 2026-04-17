---
description: Run build_runner to generate code for @JsonSerializable, freezed, etc.
---

Follow these steps to generate code for your project:

1.  **Check for dependencies**: Ensure `build_runner` and `json_serializable` (or `freezed`) are in `dev_dependencies` in `pubspec.yaml`.
2.  **Clean up previous outputs**: (Optional) Run `flutter pub run build_runner clean`.
// turbo
3.  **Run the build command**: Run `flutter pub run build_runner build --delete-conflicting-outputs`.
4.  **Verify output**: Ensure `.g.dart` files (e.g., `user_model.g.dart`) are created.
5.  **Troubleshooting**: If build fails, try `flutter clean` then `flutter pub get` and repeat step 3.
