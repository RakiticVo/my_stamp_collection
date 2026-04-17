# Dependency Management Workflow Rules

Always use this workflow when updating or managing project dependencies.

## 1. Dependency Management Rules
- **Keep Libs Updated**: Regularly check for outdated libraries using the `/update-lib` workflow.
- **Compatibility First**: When updating, prioritize `resolvable` versions that maintain compatibility with existing packages.
- **Manual Check for Major Version Bumps**: If a library has a major version update (e.g., `2.x.x` to `3.x.x`), manually verify there are no breaking changes before committing.
- **Run Tests**: Always run unit tests (`/run-tests`) after dependency updates.

## 2. Version Locking
- **Avoid Wildcards**: Use specific versions or `^` ranges as suggested by `flutter pub outdated`.
- **Verify Consistency**: Ensure `pubspec.lock` is updated after any changes to `pubspec.yaml`.
- **Wait for Completion**: Wait for `flutter pub get` and build verification before planning next steps.
