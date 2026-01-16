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

  // Specific methods for each data type
  
  /// Get cached assistants list
  List<Map<String, dynamic>>? getCachedAssistants() {
    final data = get(_assistantsKey);
    if (data == null) return null;
    try {
      return (data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Cache assistants list
  Future<void> cacheAssistants(List<Map<String, dynamic>> assistants) async {
    await put(_assistantsKey, assistants);
  }

  /// Get cached services list
  List<Map<String, dynamic>>? getCachedServices() {
    final data = get(_servicesKey);
    if (data == null) return null;
    try {
      return (data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Cache services list
  Future<void> cacheServices(List<Map<String, dynamic>> services) async {
    await put(_servicesKey, services);
  }

  /// Get cached expenses list
  List<Map<String, dynamic>>? getCachedExpenses() {
    final data = get(_expensesKey);
    if (data == null) return null;
    try {
      return (data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Cache expenses list
  Future<void> cacheExpenses(List<Map<String, dynamic>> expenses) async {
    await put(_expensesKey, expenses);
  }

  /// Get cached collaborations list
  List<Map<String, dynamic>>? getCachedCollaborations() {
    final data = get(_collaborationsKey);
    if (data == null) return null;
    try {
      return (data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Cache collaborations list
  Future<void> cacheCollaborations(List<Map<String, dynamic>> collaborations) async {
    await put(_collaborationsKey, collaborations);
  }

  /// Get cached profile
  Map<String, dynamic>? getCachedProfile() {
    final data = get(_profileKey);
    if (data == null) return null;
    try {
      return Map<String, dynamic>.from(data as Map);
    } catch (e) {
      return null;
    }
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
