import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class AppLogger {
  static const String _tag = '[ChefStation]';
  
  static void _log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final levelString = level.name.toUpperCase();
      
      switch (level) {
        case LogLevel.debug:
          debugPrint('$_tag [$levelString] $timestamp: $message');
          break;
        case LogLevel.info:
          debugPrint('$_tag [$levelString] $timestamp: $message');
          break;
        case LogLevel.warning:
          debugPrint('$_tag [$levelString] $timestamp: $message');
          break;
        case LogLevel.error:
          debugPrint('$_tag [$levelString] $timestamp: $message');
          if (error != null) {
            debugPrint('$_tag [ERROR_DETAILS] $error');
          }
          if (stackTrace != null) {
            debugPrint('$_tag [STACK_TRACE] $stackTrace');
          }
          break;
        case LogLevel.critical:
          debugPrint('$_tag [$levelString] $timestamp: $message');
          if (error != null) {
            debugPrint('$_tag [CRITICAL_ERROR] $error');
          }
          if (stackTrace != null) {
            debugPrint('$_tag [CRITICAL_STACK] $stackTrace');
          }
          break;
      }
    }
    
    // In production, you can send logs to a service like Firebase Crashlytics
    if (!kDebugMode && (level == LogLevel.error || level == LogLevel.critical)) {
      // TODO: Implement production logging service
      // FirebaseCrashlytics.instance.recordError(error ?? message, stackTrace);
    }
  }

  static void debug(String message) => _log(LogLevel.debug, message);
  static void info(String message) => _log(LogLevel.info, message);
  static void warning(String message) => _log(LogLevel.warning, message);
  static void error(String message, [Object? error, StackTrace? stackTrace]) => 
      _log(LogLevel.error, message, error, stackTrace);
  static void critical(String message, [Object? error, StackTrace? stackTrace]) => 
      _log(LogLevel.critical, message, error, stackTrace);

  // API specific logging
  static void apiCall(String endpoint, {Map<String, dynamic>? body}) {
    info('API Call: $endpoint ${body != null ? 'Body: $body' : ''}');
  }

  static void apiResponse(String endpoint, int statusCode, {String? response}) {
    if (statusCode >= 200 && statusCode < 300) {
      info('API Success: $endpoint ($statusCode)');
    } else {
      warning('API Warning: $endpoint ($statusCode) ${response ?? ''}');
    }
  }

  static void apiError(String endpoint, int statusCode, String errorMessage) {
    error('API Error: $endpoint ($statusCode) - $errorMessage');
  }

  // User action logging
  static void userAction(String action, {Map<String, dynamic>? data}) {
    info('User Action: $action ${data != null ? 'Data: $data' : ''}');
  }

  // Navigation logging
  static void navigation(String from, String to) {
    debug('Navigation: $from -> $to');
  }

  // Performance logging
  static void performance(String operation, Duration duration) {
    if (duration.inMilliseconds > 1000) {
      warning('Performance Warning: $operation took ${duration.inMilliseconds}ms');
    } else {
      debug('Performance: $operation took ${duration.inMilliseconds}ms');
    }
  }
}