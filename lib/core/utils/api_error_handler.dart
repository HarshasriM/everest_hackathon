import 'package:dio/dio.dart';
import 'logger.dart';

/// Utility class for handling API errors and providing user-friendly messages
class ApiErrorHandler {
  /// Convert API errors to user-friendly messages
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else {
      return 'An unexpected error occurred';
    }
  }

  /// Handle Dio-specific errors
  static String _handleDioError(DioException error) {
    Logger.error('DioException occurred', error: error);
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';
        
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';
        
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
        
      case DioExceptionType.cancel:
        return 'Request was cancelled';
        
      default:
        return 'Network error occurred. Please try again.';
    }
  }

  /// Handle HTTP response errors
  static String _handleResponseError(Response? response) {
    if (response == null) {
      return 'No response from server';
    }

    // Try to extract error message from response
    String errorMessage = 'Server error occurred';
    
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      errorMessage = data['message'] ?? data['error'] ?? errorMessage;
    }

    switch (response.statusCode) {
      case 400:
        return 'Invalid request: $errorMessage';
      case 401:
        return 'Authentication failed. Please login again.';
      case 403:
        return 'Access denied. You don\'t have permission to perform this action.';
      case 404:
        return 'Resource not found. The requested contact may have been deleted.';
      case 409:
        return 'Conflict: $errorMessage';
      case 422:
        return 'Validation error: $errorMessage';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Server is temporarily unavailable. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return errorMessage;
    }
  }

  /// Check if error is a network connectivity issue
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
             error.type == DioExceptionType.connectionTimeout ||
             error.type == DioExceptionType.sendTimeout ||
             error.type == DioExceptionType.receiveTimeout;
    }
    return false;
  }

  /// Check if error is a server error (5xx)
  static bool isServerError(dynamic error) {
    if (error is DioException && error.response != null) {
      final statusCode = error.response!.statusCode;
      return statusCode != null && statusCode >= 500;
    }
    return false;
  }

  /// Check if error is a client error (4xx)
  static bool isClientError(dynamic error) {
    if (error is DioException && error.response != null) {
      final statusCode = error.response!.statusCode;
      return statusCode != null && statusCode >= 400 && statusCode < 500;
    }
    return false;
  }

  /// Check if error should trigger a retry
  static bool shouldRetry(dynamic error) {
    return isNetworkError(error) || isServerError(error);
  }
}
