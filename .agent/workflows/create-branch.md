---
description: Create a new branch following my_stamp_collection project standards and push to both GitLab (origin) and GitHub (github).
---

# Create Branch Workflow

Follow this workflow when the user invokes `/create-branch` or when Rule 10 in `core.md` is triggered.

## Mandatory References

Before starting, read and follow:
- **Naming Standards**: [Naming Conventions](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_naming.md)
- **Detailed Skill**: [create_branch SKILL](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/skills/create_branch/SKILL.md)

---

## Execution Steps

### Step 1 â€” Check Git Status (Auto)
Run immediately, no need to ask:
```powershell
git branch --show-current
git remote -v
```
Inform the user: current branch and configured remotes.

---

### Step 2 â€” Collect Information
ðŸ›‘ **STOP** â€” Ask user for information:
1. **Branch type**: feature / bugfix / hotfix / refactor / release / chore
2. **Short description**: in English (e.g., `add-login`). *Skip if type is `release`*.
3. **Ticket ID** *(Optional)*: GitLab/GitHub issue number if available.

---

### Step 3 â€” Preview & Confirm
Compose branch name:
- **Release**: `release/#<ticket-id>-update-version` (or `release/update-version` if no ticket)
- **Others**: `<type>/#<ticket-id>-<short-description>` or `<type>/<short-description>`

ðŸ›‘ **STOP** â€” Display preview and wait for user confirmation (Yes / No / Edit).

---

### Step 4 â€” Create Local Branch (Auto after approval)
```powershell
git checkout <target-branch>
git pull origin <target-branch>
git checkout -b <branch-name>
```

---

### Step 5 â€” Ask to Push Remote
ðŸ›‘ **STOP** â€” Ask user which remotes to push to:
- Both (GitLab + GitHub) â€” *Default*
- GitLab only (`origin`)
- GitHub only (`github`)
- Don't push yet

---

### Step 6 â€” Push (Auto after selection)
```powershell
git push origin <branch-name>   # GitLab
git push github <branch-name>   # GitHub
```
If `github` remote is not configured â†’ ask for URL and add it before pushing.

---

### Step 7 â€” Final Report (Auto)
Summary table:

```
âœ… Branch created successfully!
  ðŸŒ¿ Branch  : <branch-name>
  ðŸ“¦ Base From : <target-branch>
  ðŸ”— GitLab  : âœ… / â­ï¸
  ðŸ”— GitHub  : âœ… / â­ï¸
```

Suggest the first commit message following the `commit-code-practices` skill.

