import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user/user.dart';

abstract interface class UserRepository {
  Future<Either<Failure, UsersPage>> getUsers({
    required int limit,
    required int skip,
  });
}
