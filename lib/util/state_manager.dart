import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chefstation_multivendor/util/logger.dart';
import 'package:chefstation_multivendor/util/error_handler.dart';

enum StateStatus {
  initial,
  loading,
  success,
  error,
  empty,
}

class StateData<T> {
  final T? data;
  final StateStatus status;
  final String? message;
  final Object? error;
  final DateTime? lastUpdated;
  final bool isFromCache;

  const StateData({
    this.data,
    this.status = StateStatus.initial,
    this.message,
    this.error,
    this.lastUpdated,
    this.isFromCache = false,
  });

  StateData<T> copyWith({
    T? data,
    StateStatus? status,
    String? message,
    Object? error,
    DateTime? lastUpdated,
    bool? isFromCache,
  }) {
    return StateData<T>(
      data: data ?? this.data,
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }

  bool get isLoading => status == StateStatus.loading;
  bool get isSuccess => status == StateStatus.success;
  bool get isError => status == StateStatus.error;
  bool get isEmpty => status == StateStatus.empty;
  bool get hasData => data != null && status == StateStatus.success;

  @override
  String toString() {
    return 'StateData(status: $status, hasData: $hasData, message: $message)';
  }
}

abstract class BaseStateController<T> extends GetxController {
  final Rx<StateData<T>> _state = StateData<T>().obs;
  late final String _cacheKey;
  final Duration _cacheExpiry;
  final bool _enableCache;

  BaseStateController({
    String? cacheKey,
    Duration? cacheExpiry,
    bool enableCache = true,
  }) : _cacheExpiry = cacheExpiry ?? const Duration(hours: 1),
       _enableCache = enableCache {
    _cacheKey = cacheKey ?? runtimeType.toString();
  }

  StateData<T> get state => _state.value;
  Rx<StateData<T>> get stateRx => _state;

  // Getters for easy access
  T? get data => state.data;
  StateStatus get status => state.status;
  String? get message => state.message;
  Object? get error => state.error;
  bool get isLoading => state.isLoading;
  bool get isSuccess => state.isSuccess;
  bool get isError => state.isError;
  bool get isEmpty => state.isEmpty;
  bool get hasData => state.hasData;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
  }

  @override
  void onClose() {
    _saveToCache();
    super.onClose();
  }

  /// Set loading state
  void setLoading([String? message]) {
    _state.value = _state.value.copyWith(
      status: StateStatus.loading,
      message: message ?? 'Loading...',
    );
  }

  /// Set success state
  void setSuccess(T data, [String? message]) {
    _state.value = _state.value.copyWith(
      data: data,
      status: StateStatus.success,
      message: message,
      lastUpdated: DateTime.now(),
      isFromCache: false,
    );
    _saveToCache();
  }

  /// Set error state
  void setError(String message, [Object? error]) {
    _state.value = _state.value.copyWith(
      status: StateStatus.error,
      message: message,
      error: error,
    );
    AppLogger.error('State Error: $message', error);
  }

  /// Set empty state
  void setEmpty([String? message]) {
    _state.value = _state.value.copyWith(
      status: StateStatus.empty,
      message: message ?? 'No data available',
    );
  }

  /// Reset state to initial
  void reset() {
    _state.value = StateData<T>();
  }

  /// Refresh data with loading state
  Future<void> refresh() async {
    setLoading('Refreshing...');
    try {
      await loadData();
    } catch (error) {
      ErrorHandler.handleError(error, context: 'StateController.refresh');
    }
  }

  /// Load data with error handling
  Future<void> loadData() async {
    try {
      setLoading();
      final result = await fetchData();
      if (result != null) {
        setSuccess(result);
      } else {
        setEmpty();
      }
    } catch (error) {
      setError('Failed to load data', error);
    }
  }

  /// Abstract method to fetch data - must be implemented by subclasses
  Future<T?> fetchData();

  /// Cache management
  Future<void> _saveToCache() async {
    if (!_enableCache || !hasData) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'data': _serializeData(data),
        'timestamp': DateTime.now().toIso8601String(),
        'status': status.name,
      };
      await prefs.setString(_cacheKey, jsonEncode(cacheData));
      AppLogger.debug('Cached data for $_cacheKey');
    } catch (error) {
      AppLogger.error('Failed to cache data', error);
    }
  }

  Future<void> _loadFromCache() async {
    if (!_enableCache) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(_cacheKey);
      
      if (cachedString != null) {
        final cachedData = jsonDecode(cachedString);
        final timestamp = DateTime.parse(cachedData['timestamp']);
        
        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          final cachedObject = _deserializeData(cachedData['data']);
          if (cachedObject != null) {
            _state.value = _state.value.copyWith(
              data: cachedObject,
              status: StateStatus.success,
              lastUpdated: timestamp,
              isFromCache: true,
            );
            AppLogger.debug('Loaded cached data for $_cacheKey');
          }
        } else {
          // Cache expired, remove it
          await prefs.remove(_cacheKey);
          AppLogger.debug('Cache expired for $_cacheKey');
        }
      }
    } catch (error) {
      AppLogger.error('Failed to load cached data', error);
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      AppLogger.debug('Cleared cache for $_cacheKey');
    } catch (error) {
      AppLogger.error('Failed to clear cache', error);
    }
  }

  /// Serialize data for caching - override if needed
  dynamic _serializeData(T? data) {
    if (data == null) return null;
    
    // Try to convert to JSON if possible
    try {
      if (data is Map) return data;
      if (data is List) return data;
      if (data is String) return data;
      if (data is num) return data;
      if (data is bool) return data;
      
      // For custom objects, try to convert to Map
      return data.toString();
    } catch (e) {
      AppLogger.warning('Could not serialize data: $e');
      return null;
    }
  }

  /// Deserialize data from cache - override if needed
  T? _deserializeData(dynamic cachedData) {
    if (cachedData == null) return null;
    
    try {
      // This is a basic implementation - override in subclasses for custom types
      return cachedData as T?;
    } catch (e) {
      AppLogger.warning('Could not deserialize data: $e');
      return null;
    }
  }
}

/// List State Controller for managing lists
abstract class BaseListStateController<T> extends BaseStateController<List<T>> {
  BaseListStateController({
    super.cacheKey,
    super.cacheExpiry,
    super.enableCache,
  });

  List<T> get items => data ?? [];
  int get itemCount => items.length;
  bool get hasItems => items.isNotEmpty;

  /// Add item to list
  void addItem(T item) {
    final currentItems = List<T>.from(items);
    currentItems.add(item);
    setSuccess(currentItems);
  }

  /// Remove item from list
  void removeItem(T item) {
    final currentItems = List<T>.from(items);
    currentItems.remove(item);
    setSuccess(currentItems);
  }

  /// Update item in list
  void updateItem(T oldItem, T newItem) {
    final currentItems = List<T>.from(items);
    final index = currentItems.indexOf(oldItem);
    if (index != -1) {
      currentItems[index] = newItem;
      setSuccess(currentItems);
    }
  }

  /// Clear all items
  void clearItems() {
    setSuccess([]);
  }

  /// Filter items
  List<T> filterItems(bool Function(T) predicate) {
    return items.where(predicate).toList();
  }

  /// Sort items
  void sortItems(int Function(T, T) compare) {
    final currentItems = List<T>.from(items);
    currentItems.sort(compare);
    setSuccess(currentItems);
  }
}

/// Pagination State Controller
abstract class PaginationStateController<T> extends BaseListStateController<T> {
  final int _pageSize;
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  PaginationStateController({
    super.cacheKey,
    super.cacheExpiry,
    super.enableCache,
    int pageSize = 20,
  }) : _pageSize = pageSize;

  int get currentPage => _currentPage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<void> loadData() async {
    _currentPage = 0;
    _hasMoreData = true;
    await super.loadData();
  }

  Future<void> loadMore() async {
    if (!_hasMoreData || _isLoadingMore) return;

    try {
      _isLoadingMore = true;
      update(); // Notify UI

      final newItems = await fetchPage(_currentPage + 1, _pageSize);
      
      if (newItems != null && newItems.isNotEmpty) {
        final currentItems = List<T>.from(items);
        currentItems.addAll(newItems);
        setSuccess(currentItems);
        _currentPage++;
        
        if (newItems.length < _pageSize) {
          _hasMoreData = false;
        }
      } else {
        _hasMoreData = false;
      }
    } catch (error) {
      setError('Failed to load more data', error);
    } finally {
      _isLoadingMore = false;
      update();
    }
  }

  /// Abstract method to fetch a specific page
  Future<List<T>?> fetchPage(int page, int pageSize);

  @override
  Future<List<T>?> fetchData() async {
    return await fetchPage(0, _pageSize);
  }
} 