import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing cached data using Hive
/// Implements a stale-while-revalidate caching strategy
class CacheService {
  static const String _boxName = 'app_cache';

  // Cache keys for different data types
  static const String _assistantsKey = 'assistants';
  static const String _servicesKey = 'services';
  static const String _expensesKey = 'expenses';
  static const String _collaborationsKey = 'collaborations';
  static const String _profileKey = 'profile';

  Box? _box;

  /// Initialize the cache service
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Get cached data for a specific key
  /// Returns null if no cached data exists
  dynamic get(String key) {
    return _box?.get(key);
  }

  /// Save data to cache for a specific key
  Future<void> put(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  /// Clear cache for a specific key
  Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  /// Clear all cached data
  Future<void> clearAll() async {
    await _box?.clear();
  }

  /// Close the cache box
  Future<void> close() async {
    await _box?.close();
  }

  /// Cache profile
  Future<void> cacheProfile(Map<String, dynamic> profile) async {
    await put(_profileKey, profile);
  }

  /// Clear all list caches (useful on logout)
  Future<void> clearAllCaches() async {
    await delete(_assistantsKey);
    await delete(_servicesKey);
    await delete(_expensesKey);
    await delete(_collaborationsKey);
    await delete(_profileKey);
  }
}
