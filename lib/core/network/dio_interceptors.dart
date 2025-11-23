import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/app_preferences_service.dart';
import '../../core/utils/logger.dart';

/// Authentication interceptor to add auth token to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _handleRequest(options, handler);
  }

  Future<void> _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = AppPreferencesService();
      await prefs.init();
      final token = await prefs.getAuthToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        Logger.warning(
          'No auth token available for request to ${options.path}',
        );
      }

      // Add device info headers
      options.headers['X-Device-Type'] = defaultTargetPlatform.name;
      options.headers['X-Request-Time'] = DateTime.now().toIso8601String();

      handler.next(options);
    } catch (e) {
      Logger.error('Error in AuthInterceptor', error: e);
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token might be expired, try to refresh
      final prefs = AppPreferencesService();
      await prefs.init();

      // Clear stored token and redirect to login
      await prefs.clearAuthData();

      // You can emit an event here to notify the app about unauthorized access
      // EventBus().fire(UnauthorizedEvent());
    }
    super.onError(err, handler);
  }
}

/// Logging interceptor for debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
      Logger.debug('Headers: ${options.headers}');
      if (options.data != null) {
        Logger.debug('Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.debug(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      Logger.debug('Response: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.error(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      Logger.error('Error: ${err.message}');
      if (err.response != null) {
        Logger.error('Error Response: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}

/// Error interceptor for handling common errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Transform error messages to user-friendly format
    if (err.response != null) {
      final data = err.response?.data;
      if (data is Map<String, dynamic>) {
        // Check for common error message fields
        final message =
            data['message'] ??
            data['error'] ??
            data['error_description'] ??
            data['detail'];

        if (message != null) {
          err = err.copyWith(error: message, message: message.toString());
        }

        // Handle validation errors
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errors = data['errors'] as Map;
          final errorMessages = errors.values
              .expand((e) => e is List ? e : [e])
              .join(', ');

          err = err.copyWith(error: errorMessages, message: errorMessages);
        }
      }
    }

    super.onError(err, handler);
  }
}

/// Retry interceptor for handling network failures
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final int retryDelay;

  RetryInterceptor({this.maxRetries = 3, this.retryDelay = 1000});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final options = err.requestOptions;
      final retryCount = options.extra['retry_count'] ?? 0;

      if (retryCount < maxRetries) {
        options.extra['retry_count'] = retryCount + 1;

        if (kDebugMode) {
          Logger.debug(
            'Retrying request... Attempt ${retryCount + 1}/$maxRetries',
          );
        }

        // Add delay before retry
        await Future.delayed(
          Duration(milliseconds: retryDelay * (retryCount + 1) as int),
        );

        try {
          final response = await Dio().fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
