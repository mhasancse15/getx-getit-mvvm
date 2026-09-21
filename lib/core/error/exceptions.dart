class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException([super.message = 'No internet connection.']);
}

class ConnectionTimeoutException extends AppException {
  const ConnectionTimeoutException([super.message = 'Connection timed out.']);
}

class ReceiveTimeoutException extends AppException {
  const ReceiveTimeoutException([super.message = 'Receiving data timed out.']);
}

class SendTimeoutException extends AppException {
  const SendTimeoutException([super.message = 'Sending data timed out.']);
}

class BadRequestException extends AppException {
  const BadRequestException([super.message = 'The request was invalid.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'You are not authorized.']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'The server returned an error.']);
}

class UnknownDioException extends AppException {
  const UnknownDioException([super.message = 'An unexpected network error occurred.']);
}
