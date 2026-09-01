class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (status: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Unable to connect to the server. Please check your internet connection.',
    super.statusCode,
    super.originalError,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server encountered an issue. Please try again later.',
    super.statusCode,
    super.originalError,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = "Today's edition isn't available yet. Please check back shortly.",
    super.statusCode = 404,
  });
}
