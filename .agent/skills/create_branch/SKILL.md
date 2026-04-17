---
name: create_branch
description: Guides the AI to create a new branch following my_stamp_collection project standards, pushing to both GitLab (origin) and GitHub (github), with an interactive Q&A process.
license: MIT
compatibility: opencode
metadata:
  language: git
  category: development
---

# Create Branch Skill — my_stamp_collection

This skill guides the AI to perform the process of creating a new branch according to project standards, pushing to both **GitLab** (`origin`) and **GitHub** (`github`) remotes.

> [!IMPORTANT]
> This skill is governed by the project's [Naming Convention Standards](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_naming.md). Always refer to this style guide for the latest naming standards and branching policy.

---

## Step 1 — Check Current Git Status

Run the following commands (no need to ask user):

```powershell
git branch --show-current
git remote -v
```

Inform the user:
- Which branch you are currently on
- Configured remotes (GitLab / GitHub)

---

## Step 2 — Collect Information from User

🛑 **STOP** and ask the user the following questions (can be asked together):

### 2a. Branch Type

```
What type of branch would you like to create?
  1. feature  — New functionality
  2. bugfix   — Standard bug fix
  3. hotfix   — Emergency fix on production
  4. refactor — Code restructuring
  5. release  — Preparation for a release version
  6. chore    — Maintenance (dependencies, config...)

Enter number or type name:
```

### 2b. Short Description

```
Provide a short description for the branch (use hyphens, English):
Example: add-enrollment-timeline, fix-hrm-date-null

*Note: If type is **release**, the description is automatically set to `update-version`.*

→ Description:
```

### 2c. Ticket ID (Optional)

```
Ticket ID (if any, e.g., GitLab Issue #45 or GitHub Issue #12):
Leave empty if none:

→ Ticket ID (Enter to skip):
```

---

## Step 3 — Summary and Confirmation

Based on the collected information, compose the branch name:

### Branch Name Logic:
- **Release Branches**: Always uses `update-version` as description.
    - With Ticket: `release/#<ticket-id>-update-version`
    - Without Ticket: `release/update-version`
- **Other Branches**:
    - With Ticket ID: `<type>/#<ticket-id>-<short-description>`
    - Without Ticket ID: `<type>/<short-description>`

### Examples:
```
type = release, ticket = 246
→ release/#246-update-version

type = feature, ticket = 45, description = add-login-screen
→ feature/#45-add-login-screen
```

### Determine Target Branch:
| Type | Target |
|------|--------|
| `feature`, `bugfix`, `refactor`, `chore` | `dev` |
| `hotfix` | `dev` AND `production` |
| `release` | `production` |

🛑 **STOP** and display a preview for user confirmation:

```
📋 New Branch Information:
  Branch Name : <computed-branch-name>
  Base From   : <target-branch>
  Push To     : origin (GitLab) + github (GitHub)

✅ Confirm creating this branch? (Yes / No / Edit)
```

---

## Step 4 — Create Local Branch

After user confirmation, execute:

```powershell
# Sync latest code from base branch
git checkout <target-branch>
git pull origin <target-branch>

# Create new branch
git checkout -b <branch-name>
```

Notification: ✅ Created branch `<branch-name>` from `<target-branch>`.

---

## Step 5 — Ask to Push to Remote

🛑 **STOP** and ask:

```
🚀 Which remotes would you like to push this branch to?
  1. Both (origin GitLab + github GitHub) ← Default
  2. Origin only (GitLab)
  3. GitHub only (github)
  4. Don't push yet, I will push later
```

---

## Step 6 — Push Branch

Push according to the user's choice:

```powershell
# Push to GitLab (if selected)
git push origin <branch-name>

# Push to GitHub (if selected)
git push github <branch-name>
```

### Handling missing github remote:
```
⚠️ Remote 'github' is not configured.
Would you like to add the GitHub remote?
If yes, provide the GitHub repository URL:
→ URL:
```

If user provides URL:
```powershell
git remote add github <github-url>
git push github <branch-name>
```

---

## Step 7 — Final Report

Summary display:

```
✅ Branch created successfully!

  🌿 Branch   : <branch-name>
  📦 Base From: <target-branch>
  🔗 GitLab   : ✅ Pushed (or ⏭️ Skipped)
  🔗 GitHub   : ✅ Pushed (or ⏭️ Skipped)

💡 Suggested first commit message:
  dd/mm/yyyy: <type>(<scope>): <initial commit subject>

You are ready to start working! 🚀
```

---

## Important Notes

- **Never** create a branch directly from `production` except for `hotfix/`.
- Always `git pull` the base branch before creating a new one.
- After merging into `dev`, delete the merged branch:
  ```powershell
  git branch -d <branch-name>
  git push origin --delete <branch-name>
  git push github --delete <branch-name>
  ```
