import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

final class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this._remoteDataSource, required this._networkInfo});

  final UserRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, UsersPage>> getUsers({
    required int limit,
    required int skip,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return left(const NoInternetFailure());
      }

      final response = await _remoteDataSource.getUsers(
        limit: limit,
        skip: skip,
      );
      return right(
        UsersPage(
          users: response.users.map((model) => model.toEntity()).toList(growable: false),
          total: response.total,
          skip: response.skip,
          limit: response.limit,
        ),
      );
    } on NoInternetException catch (error) {
      return left(NoInternetFailure(error.message));
    } on ConnectionTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on ReceiveTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on SendTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on BadRequestException catch (error) {
      return left(BadRequestFailure(error.message));
    } on UnauthorizedException catch (error) {
      return left(UnauthorizedFailure(error.message));
    } on NotFoundException catch (error) {
      return left(NotFoundFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } on UnknownDioException catch (error) {
      return left(UnexpectedFailure(error.message));
    } catch (error) {
      return left(UnexpectedFailure(error.toString()));
    }
  }
}
