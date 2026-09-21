sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message = 'No internet connection.']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out.']);
}

final class BadRequestFailure extends Failure {
  const BadRequestFailure([super.message = 'The request was invalid.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'You are not authorized.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested resource was not found.']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'The server returned an error.']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
