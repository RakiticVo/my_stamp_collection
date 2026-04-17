---
name: context_clarification
description: Guidance on how to ask for context and how to present a plan for USER approval.
---

# Context & Planning Skill (my_stamp_collection)

This skill helps you (the AI) ensure that you have all necessary context before proceeding with any action and that you obtain explicit approval for your plan. This is a MANDATORY step in the my_stamp_collection codebase.

## 1. When to Use
-   Before starting any task that involves modifying files, creating new files, or running commands that change state (e.g., `git`, `npm`, `flutter`).
-   When a USER's request is vague (e.g., "Fix this", "Add this feature").
-   When multiple implementation approaches are possible.

## 2. Best Practices for Asking
-   **Be Specific**: Instead of "What do I do?", ask "Should I modify the `UserEntity` or create a new `UserDto`?".
-   **Be Brief**: Use bullet points for questions to keep the conversation manageable.
-   **Identify Gaps**: Explicitly state what you *know* and what you *don't know*.

## 3. How to Present a Plan
-   **Structure**:
    1.  **Step 1**: Describe the first discrete action.
    2.  **Step 2**: Describe the second action.
    3.  ...
    4.  **Final Step**: Verification or cleanup.
-   **Clarity**: Use clear language and reference specific file paths (absolute paths preferred).
-   **Approval Trigger**: Close your plan with a clear call-to-action for the USER: "Does this plan look correct to you? Once you approve, I will begin."

## 4. Example Interaction
### ❌ BAD (No Clarification, No Plan Approval)
-   USER: "Update the user profile page."
-   AI: (Immediately starts changing 10 files without asking)

### ✅ GOOD (Clarification & Plan Approval)
-   USER: "Update the user profile page."
-   AI: "To ensure I have the full context, could you clarify: 
    1. Should I add new fields to the personal info section?
    2. Are there any specific design guidelines or should I follow established patterns?"
-   USER: "Add 'Address' and 'Phone' to the personal info section using established patterns."
-   AI: "Thank you. Here is my plan:
    1. Update `lib/domain/entities/user_entity.dart` to include `address` and `phone`.
    2. Update `lib/data/models/user_model.dart` and its JSON serialization.
    3. Modify `lib/presentation/widgets/user_profile_personal_info.dart` to display these fields.
    4. Run `flutter pub run build_runner build --delete-conflicting-outputs` to update models.
    Does this plan look correct to you? Once you approve, I will begin."
-   USER: "Yes, go ahead."
-   AI: (Starts working...)
