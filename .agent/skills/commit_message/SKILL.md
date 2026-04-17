---
name: commit-code-practices
description: Guide the AI to generate Git commit messages using Conventional Commits for the my_stamp_collection repository, including scope conventions and branching rules.
license: MIT
compatibility: opencode
metadata:
  language: git
  category: development
---

# Commit Code Practices - my_stamp_collection

This skill instructs the AI how to write **Git commit messages** that follow the **Conventional Commits specification** used in the my_stamp_collection repository.

> [!IMPORTANT]
> This skill is governed by the project's [Naming Convention Standards](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/styles/style_naming.md). Always ensure commit messages align with the latest version of that standard.

Always follow the commit format strictly.
âœ¨ **CRITICAL**: ALL commit messages (subject AND body) MUST be written entirely in ENGLISH.

---

# Commit Message Format

All commits must follow this structure:

dd/mm/yyyy: <type>(<scope>): <subject>

<body>

<footer>

Example:

18/03/2026: feat(po-header): add vendor validation on save

Validate that vendor number exists in system before creating
purchase order header.

Closes #123

---

# Date Prefix Rules

Each commit message must start with the date in **dd/mm/yyyy** format followed by a colon and a space.

Rules:

- format: **dd/mm/yyyy: **
- followed by the conventional commit `<type>(<scope>): <subject>`

Example:

18/03/2026: feat(po-header): add vendor validation

---

# Allowed Commit Types

Use only the following commit types:

- feat â€” new feature
- fix â€” bug fix
- docs â€” documentation change
- style â€” formatting change only
- refactor â€” code restructuring without behavior change
- perf â€” performance improvement
- test â€” test additions or updates
- chore â€” build system or dependency updates
- ci â€” CI/CD configuration changes
- revert â€” revert previous commit

---

# Scope Guidelines

Scopes identify which module or domain the change affects.

Common scopes used in this repository:

- po-header â€” Purchase Order headers
- po-line â€” Purchase Order line items
- store-order â€” Store Order management
- vendor â€” Vendor management
- promotion â€” Promotion logic
- inventory â€” Inventory operations
- auth â€” authentication and authorization
- localization â€” translations and localization
- ui â€” user interface
- api â€” API layer
- db â€” database changes
- deploy â€” deployment configuration

Example:

18/03/2026: feat(po-header): add vendor validation

---

# Subject Rules

The subject line must follow these rules:

- use **imperative mood**
- do not capitalize the first letter
- do not end with a period
- limit to **50 characters**
- keep it concise but descriptive
- **FEATURE MENTION**: Mandatory to state the affected functionality/feature (e.g., "in KPI feature", "for sales report").

Correct:

add vendor validation  
fix store order status calculation

Incorrect:

Added vendor validation  
Fix store order status.

---

# Body Guidelines

The body explains **why the change exists**.

Rules:

- explain what and why, not how
- wrap lines at **72 characters**
- separate from subject with a blank line
- use bullet points if multiple changes exist

Example:

18/03/2026: fix(store-order): correct status calculation for frozen orders

Previously frozen orders were included in active order counts.
Exclude frozen orders from activity calculations.

Closes #1234

---

# Footer Usage

The footer is used for issue references or breaking changes.

Examples:

Closes #123  
Fixes #456

BREAKING CHANGE: approval workflow updated

---

# Commit Best Practices

Follow these principles:

1. Each commit must represent **one logical change**
2. Keep commits **atomic**
3. Explain **why the change is needed**
4. Reference related issues
5. Use consistent scope naming
6. Keep subject concise

Example of good commits:

18/03/2026: feat(po-header): add vendor validation

18/03/2026: fix(store-order): correct status calculation for frozen orders

18/03/2026: refactor(api-client): extract http error handling utility

---

# Bad Commit Examples

Avoid vague commit messages such as:

Update stuff  
Fixed bug  
WIP  
asdfasdfasdf

feat: added new feature for vendor selection in purchase order

fix: various improvements and bug fixes

---

# Performance Commit Example

perf(po-query): optimize vendor loading query

Use compiled LINQ query to reduce query execution time.

Before: 2500ms for 500 records  
After: 250ms for 500 records

---

# Git Workflow

Typical workflow:

Create feature branch:

git checkout -b feat/po-header-validation

Commit changes:

git commit -m "18/03/2026: feat(po-header): add vendor validation"

Create merge request.

After review:

git merge --ff-only feat/po-header-validation

---

# Repository Branching Rules

Branch policy for this repository:

1. Only **hotfix/** branches can target `main`
2. **feat/**, **fix/**, **chore/** must target `dev`
3. Releases must use **release/** branches
4. After release merge `main â†’ dev`
5. Remove merged branches after successful merge

Example flows:

Regular fix:

fix/store-order-lock-permission â†’ dev

Release:

release/v1.12.4 â†’ main  
main â†’ dev

Hotfix:

hotfix/payment-timeout â†’ main

---

# Important Notes

Always:

- use imperative mood
- keep commits atomic
- always include the date prefix (**dd/mm/yyyy: **)
- reference related issues
- keep subject concise
- follow repository scope naming

---

# README History Updates

When updating the `History Version` section in `README.md`, follow these guidelines:

1. **User-Oriented**: Write for the end-user or client, not for developers.
2. **Functional Focus**: Describe *what* changed from a functional perspective (e.g., "Improve KPI dashboard", "Update login flow").
3. **No Technical Jargon**: NEVER use technical terms like "Refactor", "Bloc", "Cubit", "State Management", or internal standards like "Rakitic standards".
4. **Concise**: Keep each entry to one line if possible.

**Correct Example**:
`- **v1.6.0** - Launch new Inventory Tracking feature and improve order search performance.`

**Incorrect Example**:
`- **v1.6.0** - Refactor Inventory Bloc and apply Rakitic standards to Order search.`

