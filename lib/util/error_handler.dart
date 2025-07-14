import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chefstation_multivendor/util/logger.dart';

import 'package:chefstation_multivendor/common/widgets/custom_snackbar_widget.dart';

enum ErrorType {
  network,
  authentication,
  validation,
  server,
  unknown,
  timeout,
  permission,
  notFound,
}

class AppError {
  final String message;
  final ErrorType type;
  final String? code;
  final Object? originalError;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    required this.type,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  factory AppError.fromException(dynamic exception, [StackTrace? stackTrace]) {
    if (exception is AppError) return exception;

    String message;
    ErrorType type;

    if (exception.toString().contains('SocketException') ||
        exception.toString().contains('NetworkException')) {
      type = ErrorType.network;
      message = 'network_error'.tr;
    } else if (exception.toString().contains('401') ||
               exception.toString().contains('Unauthorized')) {
      type = ErrorType.authentication;
      message = 'authentication_error'.tr;
    } else if (exception.toString().contains('422') ||
               exception.toString().contains('Validation')) {
      type = ErrorType.validation;
      message = 'validation_error'.tr;
    } else if (exception.toString().contains('500') ||
               exception.toString().contains('Internal Server Error')) {
      type = ErrorType.server;
      message = 'server_error'.tr;
    } else if (exception.toString().contains('Timeout')) {
      type = ErrorType.timeout;
      message = 'timeout_error'.tr;
    } else if (exception.toString().contains('403') ||
               exception.toString().contains('Forbidden')) {
      type = ErrorType.permission;
      message = 'permission_error'.tr;
    } else if (exception.toString().contains('404') ||
               exception.toString().contains('Not Found')) {
      type = ErrorType.notFound;
      message = 'not_found_error'.tr;
    } else {
      type = ErrorType.unknown;
      message = 'unknown_error'.tr;
    }

    return AppError(
      message: message,
      type: type,
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => 'AppError($type): $message';
}

class ErrorHandler {
  static void handleError(
    dynamic error, {
    String? context,
    bool showSnackBar = true,
    VoidCallback? onError,
  }) {
    final appError = AppError.fromException(error);
    
    // Log the error
    AppLogger.error(
      'Error in $context: ${appError.message}',
      appError.originalError,
      appError.stackTrace,
    );

    // Handle specific error types
    switch (appError.type) {
      case ErrorType.authentication:
        _handleAuthenticationError(appError);
        break;
      case ErrorType.network:
        _handleNetworkError(appError, showSnackBar);
        break;
      case ErrorType.validation:
        _handleValidationError(appError, showSnackBar);
        break;
      case ErrorType.server:
        _handleServerError(appError, showSnackBar);
        break;
      case ErrorType.timeout:
        _handleTimeoutError(appError, showSnackBar);
        break;
      case ErrorType.permission:
        _handlePermissionError(appError, showSnackBar);
        break;
      case ErrorType.notFound:
        _handleNotFoundError(appError, showSnackBar);
        break;
      case ErrorType.unknown:
        _handleUnknownError(appError, showSnackBar);
        break;
    }

    // Call custom error handler if provided
    onError?.call();
  }

  static void _handleAuthenticationError(AppError error) {
    // Clear user session and redirect to login
    // Get.find<AuthController>().logout();
    Get.offAllNamed('/login');
    showCustomSnackBar(error.message);
  }

  static void _handleNetworkError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _handleValidationError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _handleServerError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _handleTimeoutError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _handlePermissionError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _handleNotFoundError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _handleUnknownError(AppError error, bool showSnackBar) {
    if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  // Async error handling wrapper
  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? context,
    bool showSnackBar = true,
    T? defaultValue,
  }) async {
    try {
      return await operation();
    } catch (error) {
      handleError(error, context: context, showSnackBar: showSnackBar);
      return defaultValue;
    }
  }

  // Widget error boundary
  static Widget errorBoundary({
    required Widget child,
    required Widget Function(Object error, StackTrace stackTrace) errorBuilder,
  }) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      AppLogger.error(
        'Widget Error: ${details.exception}',
        details.exception,
        details.stack,
      );
      return errorBuilder(details.exception, details.stack ?? StackTrace.current);
    };
    return child;
  }
}

// Extension for easier error handling
extension ErrorHandlingExtension<T> on Future<T> {
  Future<T?> handleError({
    String? context,
    bool showSnackBar = true,
    T? defaultValue,
  }) {
    return ErrorHandler.handleAsync(
      () => this,
      context: context,
      showSnackBar: showSnackBar,
      defaultValue: defaultValue,
    );
  }
} 