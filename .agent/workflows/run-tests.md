---
description: How to run unit tests and observe the request/response logs.
---

# Unit Testing Workflow

Follow these steps to run your tests and see the logged request data.

## 1. Unit Test Rules
Refer to the **Testing Rules**: [workflow_testing.md](file:///c:/Work/FlutterProjects/my_stamp_collection/.agent/rules/workflow_testing.md)

## 2. Running Tests
1.  Open the terminal in the project root.
2.  Run the test for a specific file:
    ```bash
    flutter test test/path/to/your_test.dart
    ```
3.  To see detailed output (including print statements):
    ```bash
    flutter test --reporter expanded
    ```
4.  Verify that the "Test Request Data: {JSON}" logs are visible in the output for each test case.

