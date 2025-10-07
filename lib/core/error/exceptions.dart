/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  final int? code;
  
  const AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server exception for API errors
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
  });
}

/// Network exception for connectivity issues
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Cache exception for local storage errors
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.code,
  });
}

/// Validation exception for input validation errors
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  
  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code,
  });
}

/// Authentication exception for auth-related errors
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
  });
}

/// Timeout exception for request timeouts
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timeout',
    super.code,
  });
}

/// Unknown exception for unexpected errors
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred',
    super.code,
  });
}
