# Update Dependencies Skill

## Description
This skill automates the process of checking for outdated Flutter dependencies and updating them in `pubspec.yaml` while respecting version constraints and ensuring compatibility.

## Usage
1. Run the `update_libs.py` script to fetch outdated packages and update `pubspec.yaml`.
2. Analyze the output to identify major version changes or potential conflicts.
3. Run `flutter pub get` after updates.

## Key Files
- `scripts/update_libs.py`: Python script that identifies direct/dev outdated packages and updates `pubspec.yaml`.

## Guidelines
- Always ensure `pubspec.yaml` exists in the root directory.
- The script uses regex to update version constraints (starting with `^`).
- It focuses on `direct` and `dev` dependencies.
- It automatically runs `flutter pub get` after applying changes.
