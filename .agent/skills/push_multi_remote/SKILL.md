---
name: push-multi-remote
description: Guide on configuring and pushing code to both GitLab (primary) and GitHub (secondary).
---

# Multi-Remote Git Synchronization

This skill provides instructions on how to push the repository to multiple git remotes, specifically GitLab (usually `origin`) and GitHub.

## Checking Remotes
To see the currently configured remotes:
```powershell
git remote -v
```
Typically:
- `origin` is mapped to GitLab.
- `github` is mapped to GitHub.

## Adding a New Remote
If the `github` remote is missing, prompt the user for the GitHub repository link, then add it:
```powershell
git remote add github <github_repository_url>
```

## Pushing to Multiple Remotes
To push the current branch to both remotes:
```powershell
git push origin HEAD
git push github HEAD
```

**Note:** The user might only want to push to GitLab. Always confirm if they also want to push to GitHub when completing a task, unless they already specified their preference.

## Handling Conflicts
If the GitHub remote rejects the push (e.g., non-fast-forward), you might need to run `git pull github <branch-name>` or ask the user for permission to force-push if it's strictly a mirror/backup.
