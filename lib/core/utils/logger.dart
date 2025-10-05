import 'package:flutter/foundation.dart';

/// Simple logger utility for debugging
class Logger {
  static const String _prefix = '[SHE]';
  
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr DEBUG: $message');
    }
  }
  
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr INFO: $message');
    }
  }
  
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr WARNING: $message');
    }
  }
  
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr ERROR: $message');
      if (error != null) {
        print('Error Object: $error');
      }
      if (stackTrace != null) {
        print('Stack Trace:\n$stackTrace');
      }
    }
  }
  
  static void network(String message, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      print('$_prefix[NETWORK] $message');
      if (data != null) {
        data.forEach((key, value) {
          print('  $key: $value');
        });
      }
    }
  }
  
  static void bloc(String blocName, String event, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      print('$_prefix[BLOC][$blocName] Event: $event');
      if (data != null) {
        data.forEach((key, value) {
          print('  $key: $value');
        });
      }
    }
  }
}
