# Git Branch Rules - my_stamp_collection

Branch naming and management rules for the my_stamp_collection project.
Applies to both **GitLab** (primary / `origin`) and **GitHub** (secondary / `github`).

---

## 1. Branch Structure

### Fixed Branches (Protected)
| Branch Name | Purpose |
|-------------|---------|
| `dev`       | Main integration branch. All feature/fix/chore branches merge here. |
| `production`| Release branch. Only accepts direct pushes from `dev` when ready for release. |

> ⛔ **NEVER** commit directly to `dev` or `production`.

---

## 2. Branch Naming Convention

### Standard Format

```
<type>/<short-description>
```

Or if there is a Ticket ID:

```
<type>/#<ticket-id>-<short-description>
```

### Naming Rules
- Use **all lowercase**
- Use hyphens `-` to separate words (do not use `_` or spaces)
- **Concise and clear** (maximum 5-6 words)
- No special characters or non-ASCII characters

---

## 3. Branch Types

| Type          | Prefix       | Target Branch       | Description |
|---------------|--------------|---------------------|-------------|
| New Feature   | `feature/`   | `dev`               | Developing a new functionality |
| Bug Fix       | `bugfix/`    | `dev`               | Standard bug fix |
| Emergency Fix | `hotfix/`    | `dev` & `production`| Critical fix for production |
| Refactoring   | `refactor/`  | `dev`               | Code cleanup, no behavior change |
| Release Prep  | `release/`   | `production`        | Preparing a release version |
| Maintenance   | `chore/`     | `dev`               | Updating dependencies, config, CI/CD |

### Real-world Examples

```
feature/add-enrollment-timeline
feature/#45-add-login-screen
bugfix/fix-hrm-date-calculation
bugfix/#12-fix-cart-null-error
hotfix/critical-auth-token-expired
refactor/clean-up-enroll-bloc
release/v1.3.0
release/#246-update-version  # Special: 'update-version' is default for release branches
chore/update-flutter-dependencies
```

---

## 4. Branching Flow

```
production
    ↑
    dev  ←── feature/xxx
         ←── bugfix/xxx
         ←── refactor/xxx
         ←── chore/xxx
```

**Hotfix flow** (emergency fix):
```
hotfix/xxx → dev
           → production  (direct push)
```

**Release flow**:
```
dev → production  (direct push, no merge request required)
```

---

## 5. Mandatory Control Points

- **Before creating a branch**: Always run `git pull origin dev` to sync with the latest code.
- **After creating a branch**: Push immediately to both remotes (`origin` & `github`) to register the branch.
- **After merging**: Delete the merged branch both locally and on remotes.

---

## 6. References

- Commit rules: [workflow_commit.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/workflow_commit.md)
- Push multi-remote: [push_multi_remote SKILL](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/skills/push_multi_remote/SKILL.md)
