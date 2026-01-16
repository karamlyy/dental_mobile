import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Helper class for Firebase Crashlytics operations
class CrashlyticsHelper {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Log a custom error to Crashlytics
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   // risky operation
  /// } catch (e, stack) {
  ///   CrashlyticsHelper.logError(e, stack, reason: 'Failed to fetch data');
  /// }
  /// ```
  static Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Log a custom message to Crashlytics
  /// 
  /// Example:
  /// ```dart
  /// CrashlyticsHelper.log('User clicked on submit button');
  /// ```
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// Set user identifier for Crashlytics
  /// 
  /// Example:
  /// ```dart
  /// CrashlyticsHelper.setUserId('user123');
  /// ```
  static Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Set custom key-value pairs for better crash context
  /// 
  /// Example:
  /// ```dart
  /// CrashlyticsHelper.setCustomKey('user_role', 'doctor');
  /// CrashlyticsHelper.setCustomKey('clinic_id', '123');
  /// ```
  static Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Force a crash (for testing purposes only)
  /// 
  /// **WARNING:** Only use this in debug mode for testing!
  /// 
  /// Example:
  /// ```dart
  /// if (kDebugMode) {
  ///   CrashlyticsHelper.forceCrash();
  /// }
  /// ```
  static void forceCrash() {
    _crashlytics.crash();
  }

  /// Enable/disable Crashlytics collection
  /// 
  /// Example:
  /// ```dart
  /// // Disable for debugging
  /// CrashlyticsHelper.setCrashlyticsCollectionEnabled(false);
  /// ```
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  /// Check if Crashlytics collection is enabled
  static bool isCrashlyticsCollectionEnabled() {
    return _crashlytics.isCrashlyticsCollectionEnabled;
  }

  /// Send any unsent crash reports to Firebase
  static Future<void> sendUnsentReports() async {
    await _crashlytics.sendUnsentReports();
  }

  /// Delete any unsent crash reports
  static Future<void> deleteUnsentReports() async {
    await _crashlytics.deleteUnsentReports();
  }

  /// Check if the app crashed on the previous execution
  static Future<bool> didCrashOnPreviousExecution() async {
    return await _crashlytics.didCrashOnPreviousExecution();
  }
}
