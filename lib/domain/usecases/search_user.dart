
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user/user.dart';
import '../repositories/user_repository.dart';

final class SearchUsers {
  SearchUsers(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, UsersPage>> call({
    required String query,
    required int limit,
    required int skip,
  }) {
    return _repository.searchUsers(
      query: query,
      limit: limit,
      skip: skip,
    );
  }
}