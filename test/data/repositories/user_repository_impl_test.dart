import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getxwithmvvmdemo/core/error/exceptions.dart';
import 'package:getxwithmvvmdemo/core/error/failures.dart';
import 'package:getxwithmvvmdemo/core/network/network_info.dart';
import 'package:getxwithmvvmdemo/data/datasources/user_remote_data_source.dart';
import 'package:getxwithmvvmdemo/data/models/user/user_model.dart';
import 'package:getxwithmvvmdemo/data/models/user/users_response_model.dart';
import 'package:getxwithmvvmdemo/data/repositories/user_repository_impl.dart';
import 'package:mocktail/mocktail.dart';


class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource dataSource;
  late MockNetworkInfo networkInfo;
  late UserRepositoryImpl repository;

  setUp(() {
    dataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: dataSource,
      networkInfo: networkInfo,
    );
  });

  test('maps remote data to domain data on success', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => dataSource.getUsers(limit: 20, skip: 0)).thenAnswer(
      (_) async => const UsersResponseModel(
        users: <UserModel>[
          UserModel(id: 1, firstName: 'Emily', lastName: 'Johnson'),
        ],
        total: 1,
        skip: 0,
        limit: 20,
      ),
    );

    final result = await repository.getUsers(limit: 20, skip: 0);

    expect(result.isRight(), isTrue);
    result.fold((_) {}, (page) {
      expect(page.users.single.fullName, 'Emily Johnson');
    });
  });

  test('returns a server failure when the data source throws', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => dataSource.getUsers(limit: 20, skip: 0))
        .thenThrow(const ServerException('Server unavailable'));

    final result = await repository.getUsers(limit: 20, skip: 0);

    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Expected a failure'),
    );
  });
}
