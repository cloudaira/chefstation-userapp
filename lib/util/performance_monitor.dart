import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:chefstation_multivendor/util/logger.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<Duration>> _metrics = {};
  static final Map<String, int> _counters = {};
  
  // Memory usage tracking
  static final List<double> _memoryUsage = [];
  static Timer? _memoryTimer;

  // Performance thresholds
  static const Duration _slowOperationThreshold = Duration(milliseconds: 1000);
  static const Duration _verySlowOperationThreshold = Duration(milliseconds: 3000);
  static const int _maxMemoryUsageMB = 500;

  /// Start timing an operation
  static void startTimer(String operationName) {
    if (kDebugMode) {
      _timers[operationName] = Stopwatch()..start();
      AppLogger.debug('Performance: Started timing $operationName');
    }
  }

  /// End timing an operation and log the result
  static void endTimer(String operationName) {
    if (kDebugMode && _timers.containsKey(operationName)) {
      final stopwatch = _timers.remove(operationName)!;
      stopwatch.stop();
      final duration = stopwatch.elapsed;

      // Store metric for analysis
      _metrics.putIfAbsent(operationName, () => []).add(duration);

      // Log based on performance
      if (duration > _verySlowOperationThreshold) {
        AppLogger.warning('Performance: $operationName took ${duration.inMilliseconds}ms (VERY SLOW)');
      } else if (duration > _slowOperationThreshold) {
        AppLogger.warning('Performance: $operationName took ${duration.inMilliseconds}ms (SLOW)');
      } else {
        AppLogger.debug('Performance: $operationName took ${duration.inMilliseconds}ms');
      }
    }
  }

  /// Time an async operation
  static Future<T> timeAsync<T>(String operationName, Future<T> Function() operation) async {
    startTimer(operationName);
    try {
      final result = await operation();
      endTimer(operationName);
      return result;
    } catch (error) {
      endTimer(operationName);
      rethrow;
    }
  }

  /// Time a sync operation
  static T timeSync<T>(String operationName, T Function() operation) {
    startTimer(operationName);
    try {
      final result = operation();
      endTimer(operationName);
      return result;
    } catch (error) {
      endTimer(operationName);
      rethrow;
    }
  }

  /// Track memory usage
  static void startMemoryTracking() {
    if (kDebugMode && _memoryTimer == null) {
      _memoryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _trackMemoryUsage();
      });
    }
  }

  static void stopMemoryTracking() {
    _memoryTimer?.cancel();
    _memoryTimer = null;
  }

  static void _trackMemoryUsage() {
    // In a real app, you would use a memory monitoring package
    // For now, we'll simulate memory tracking
    final memoryUsage = _getCurrentMemoryUsage();
    _memoryUsage.add(memoryUsage);

    if (memoryUsage > _maxMemoryUsageMB) {
      AppLogger.warning('Memory Usage: ${memoryUsage.toStringAsFixed(2)}MB (HIGH)');
    } else {
      AppLogger.debug('Memory Usage: ${memoryUsage.toStringAsFixed(2)}MB');
    }

    // Keep only last 100 measurements
    if (_memoryUsage.length > 100) {
      _memoryUsage.removeAt(0);
    }
  }

  static double _getCurrentMemoryUsage() {
    // This is a placeholder - in a real app, use a memory monitoring package
    // return ProcessInfo.currentRss / 1024 / 1024; // Convert to MB
    return 100.0 + (DateTime.now().millisecondsSinceEpoch % 50); // Simulated value
  }

  /// Increment a counter
  static void incrementCounter(String counterName) {
    if (kDebugMode) {
      _counters[counterName] = (_counters[counterName] ?? 0) + 1;
    }
  }

  /// Get counter value
  static int getCounter(String counterName) {
    return _counters[counterName] ?? 0;
  }

  /// Get performance metrics
  static Map<String, dynamic> getMetrics() {
    final metrics = <String, dynamic>{};
    
    for (final entry in _metrics.entries) {
      final durations = entry.value;
      if (durations.isNotEmpty) {
        final avg = durations.map((d) => d.inMilliseconds).reduce((a, b) => a + b) / durations.length;
        final min = durations.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b);
        final max = durations.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b);
        
        metrics[entry.key] = {
          'count': durations.length,
          'average_ms': avg.round(),
          'min_ms': min,
          'max_ms': max,
        };
      }
    }

    return metrics;
  }

  /// Get memory usage statistics
  static Map<String, dynamic> getMemoryStats() {
    if (_memoryUsage.isEmpty) return {};

    final avg = _memoryUsage.reduce((a, b) => a + b) / _memoryUsage.length;
    final min = _memoryUsage.reduce((a, b) => a < b ? a : b);
    final max = _memoryUsage.reduce((a, b) => a > b ? a : b);

    return {
      'current_mb': _getCurrentMemoryUsage(),
      'average_mb': avg,
      'min_mb': min,
      'max_mb': max,
      'samples': _memoryUsage.length,
    };
  }

  /// Clear all metrics
  static void clearMetrics() {
    _timers.clear();
    _metrics.clear();
    _counters.clear();
    _memoryUsage.clear();
  }

  /// Generate performance report
  static String generateReport() {
    final metrics = getMetrics();
    final memoryStats = getMemoryStats();
    final counters = Map<String, int>.from(_counters);

    final report = StringBuffer();
    report.writeln('=== PERFORMANCE REPORT ===');
    report.writeln('Generated: ${DateTime.now()}');
    report.writeln();

    if (metrics.isNotEmpty) {
      report.writeln('OPERATION METRICS:');
      metrics.forEach((operation, data) {
        report.writeln('  $operation:');
        report.writeln('    Count: ${data['count']}');
        report.writeln('    Average: ${data['average_ms']}ms');
        report.writeln('    Min: ${data['min_ms']}ms');
        report.writeln('    Max: ${data['max_ms']}ms');
        report.writeln();
      });
    }

    if (memoryStats.isNotEmpty) {
      report.writeln('MEMORY STATS:');
      report.writeln('  Current: ${memoryStats['current_mb']?.toStringAsFixed(2)}MB');
      report.writeln('  Average: ${memoryStats['average_mb']?.toStringAsFixed(2)}MB');
      report.writeln('  Min: ${memoryStats['min_mb']?.toStringAsFixed(2)}MB');
      report.writeln('  Max: ${memoryStats['max_mb']?.toStringAsFixed(2)}MB');
      report.writeln('  Samples: ${memoryStats['samples']}');
      report.writeln();
    }

    if (counters.isNotEmpty) {
      report.writeln('COUNTERS:');
      counters.forEach((name, count) {
        report.writeln('  $name: $count');
      });
    }

    return report.toString();
  }

  /// Log performance report
  static void logReport() {
    if (kDebugMode) {
      AppLogger.info('Performance Report:\n${generateReport()}');
    }
  }
}

// Extension for easier performance monitoring
extension PerformanceMonitoringExtension<T> on Future<T> {
  Future<T> monitorPerformance(String operationName) {
    return PerformanceMonitor.timeAsync(operationName, () => this);
  }
}

extension SyncPerformanceMonitoringExtension<T> on T Function() {
  T monitorPerformance(String operationName) {
    return PerformanceMonitor.timeSync(operationName, this);
  }
} 