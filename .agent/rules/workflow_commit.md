# Git Commit & Push Workflow Rules

Always use this workflow when committing and pushing code.

## 1. Commit & Push Rules
- **Strictly English**: The `commit message` (including subject and body) MUST be written entirely in English.
- **Feature Mention**: Every commit message MUST explicitly state which feature or functionality is affected (e.g., "in KPI feature").
- **Version Verification**: Extract the version from `pubspec.yaml` or the current Git branch. Propose this version alongside the commit message for USER approval.
- **Version Correction**: If the USER provides a corrected version, you MUST update `pubspec.yaml` and rename the local branch accordingly.
- **History Update**: You MUST update the `History Version` section in `README.md` with the finalized version and commit subject BEFORE executing the commit.
- **Approval Checkpoint 1 - Commit**: You MUST propose the commit message and version and obtain explicit USER approval BEFORE executing `git commit`.
- **Approval Checkpoint 2 - Remotes**: After committing, check existing remotes with `git remote -v`, show the list, and ask the USER which remote(s) to push to BEFORE running `git push`.
- **Functional Description**: Descriptions in `README.md` MUST be **User/Client-oriented**. Focus on functional updates (e.g., "Launch X feature", "Optimized Y performance") and AVOID technical details, code jargon, or repository-specific standards (e.g., do NOT mention "Refactor Bloc", "Fix bug in Cubit", or "Apply Rakitic standards"). Imagine explaining the changes to someone who doesn't know how to code.
- **Stop Points (🛑)**: Do NOT proceed until the USER provides permission for both the commit itself and the remotes to push to.
