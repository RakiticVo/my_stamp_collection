---
description: Check changes, propose a commit message, wait for user approval, and conditionally push to GitLab and GitHub.
---

# Commit and Push Workflow

Follow these exact steps when the user invokes `/commit-push`.

## 1. Commit & Push Rules
Refer to the **Commit Rules**: [Naming Conventions](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_naming.md)

## 2. Execution Steps
1. **Check Changes**: Run `git status` and `git diff` to analyze current modifications.
2. **Identify Version & Message**:
   - Extract the current app version from `pubspec.yaml` or the current branch name.
   - Formulate a commit message matching the `commit-code-practices` skill conventions. Format: `dd/mm/yyyy: <type>(<scope>): <subject>`.
3. **Ask for Approval & Version Verification**:
   - Show the message AND the version.
   - Ask: *"Do you approve this commit message and the version **vX.Y.Z**? (Yes/No)"*
   - ðŸ›‘ **STOP**. Wait for response.
4. **Version Correction & Sync (Optional)**: If the user corrects the version:
   - Update `version: <new_version>` in `pubspec.yaml`.
   - Rename local branch: `git branch -m update_version_<new_version>`.
5. **Update README.md**: 
   - Add the version to the `History Version` section.
   - âš ï¸ **MANDATORY**: The description MUST be **User/Client-oriented**. 
   - Focus on **functional changes** (e.g., "Launch X", "Fix Y").
   - **AVOID** technical jargon (e.g., "Refactor", "Bloc", "rakitic standards").
6. **Commit & Check Remotes**:
   - Run `git add .` and `git commit -m "<approved_message>"`.
   - Run `git remote -v` and show list to the USER.
7. **Ask for Push Remotes**:
   - Ask: *"Which remotes do you want to push this code to?"*
   - ðŸ›‘ **STOP**. Wait for decision.
8. **Push Code**:
   - Run `git push <remote> HEAD`.

