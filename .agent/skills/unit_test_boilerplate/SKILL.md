# Skill: Unit Test Generation
---
name: unit_test_boilerplate
description: Generate unit test boilerplate for Usecases and Blocs following project standards.
---

Use this skill to quickly create a test file for a new Usecase or Bloc.

### Instructions
1.  **Placement**: Tests should be in the root `test/` directory, mirroring the `lib/` structure.
    - Example: `test/modules/hrm/user_info/basic_info/domain/usecase/get_basic_info_usecase_test.dart`.
2.  **Usecase Test Template**:
    - [ ] Create a `MockRepository`.
    - [ ] Call `setUp` to instantiate the Usecase with the mock.
    - [ ] Write `test` blocks for success and failure scenarios.
3.  **Bloc/Cubit Test Template**:
    - [ ] Use `bloc_test` package.
    - [ ] Mock the Usecases.
    - [ ] Verify state transitions using `expect`.
4.  **Logging**: Always log the request data before the action to aid observability.
    - `print('Request Data: ${request.toJson()}');`

### Example Usecase Test:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// imports...

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late GetUserUsecase usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUserUsecase(repository: mockRepository);
  });

  test('should get user from repository', () async {
    // arrange
    print('Test Request Data: ${NoParams().toString()}');
    when(() => mockRepository.getUser()).thenAnswer((_) async => Right(tUser));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(tUser));
    verify(() => mockRepository.getUser());
  });
}
```
