import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getxwithmvvmdemo/core/error/failures.dart';
import 'package:getxwithmvvmdemo/domain/entities/user/user.dart';
import 'package:getxwithmvvmdemo/domain/repositories/user_repository.dart';
import 'package:getxwithmvvmdemo/domain/usecases/get_users.dart';
import 'package:mocktail/mocktail.dart';



class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late GetUsers useCase;

  setUp(() {
    repository = MockUserRepository();
    useCase = GetUsers(repository);
  });

  test('returns a page from the repository', () async {
    const page = UsersPage(users: <User>[], total: 0, skip: 0, limit: 20);
    when(() => repository.getUsers(limit: 20, skip: 0))
        .thenAnswer((_) async => const Right<Failure, UsersPage>(page));

    final result = await useCase(limit: 20, skip: 0);

    expect(result, const Right<Failure, UsersPage>(page));
    verify(() => repository.getUsers(limit: 20, skip: 0)).called(1);
  });
}
