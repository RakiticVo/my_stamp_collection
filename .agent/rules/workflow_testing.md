# Unit Testing Workflow Rules

Always use this workflow when creating or running unit tests in the project.

## 1. Unit Test Rules
- **Request Logging**: In unit tests, always print the input data (Request objects) in JSON format before executing the action. This aids in debugging failed tests by showing exactly what was sent to the mocked layer.
    - Format: `print('Test Request Data: ${request.toJson()}');`
- **Mocktail Usage**: Use `mocktail` for mocking and `registerFallbackValue` in `setUpAll` for custom types.
- **Strict Testing**: Ensure all Usecases and Cubits are covered by unit tests.
- **Execution**: Run unit tests (`/run-tests`) after any changes to logic or dependencies.

## 2. Test Structure
- **Group**: Organize tests into logical groups (`setUpAll`, `test`, `expect`).
- **Wait for Completion**: Use `expectLater` for asynchronous events and `completer` if needed.
- **Wait for Emission**: For BLoC tests, use `emits` or `emitsInOrder` to verify state transitions.
