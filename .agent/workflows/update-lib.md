---
description: Refresh and update Flutter dependencies across the project.
---

# Update Project Dependencies Workflow

Follow these steps to update all project libraries and ensure they are compatible.

## 1. Dependency Management Rules
Refer to the **Dependency Rules**: [workflow_dependencies.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/workflow_dependencies.md)

## 2. Update Process
1. **Check for Outdated Packages**: Use `flutter pub outdated` to see which packages have newer versions.
// turbo
2. **Apply Updates Automatically**: Run the `update_libs.py` skill to identify and apply updates to `pubspec.yaml` for both direct and dev dependencies.
```powershell
python .agent/skills/update_dependencies/scripts/update_libs.py
```
3. **Verify Compatibility**: After the script runs, check the output for any major version bumps or errors. `flutter pub get` is run automatically by the script.
4. **Final Check**: Run `flutter pub get` manually if needed and verify that the project still builds.
```powershell
flutter pub get
```
