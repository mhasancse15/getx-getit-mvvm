import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user/user.dart';
import '../repositories/user_repository.dart';

final class GetUsers {
  GetUsers(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, UsersPage>> call({
    required int limit,
    required int skip,
  }) {
    return _repository.getUsers(limit: limit, skip: skip);
  }
}
