import 'dart:async';
import 'package:dental_mobile/app.dart';
import 'package:dental_mobile/config/flavor_config.dart';
import 'package:dental_mobile/core/cache/cache_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/di.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'firebase_options_dev.dart' as firebase_dev;
import 'firebase_options_prod.dart' as firebase_prod;

void main() async {
  runZonedGuarded<Future<void>>(() async {
    // WidgetsFlutterBinding.ensureInitialized(); is already called in main_dev.dart or main_prod.dart
    
    // Determine which Firebase options to use based on flavor
    final firebaseOptions = FlavorConfig.instance.isDev
        ? firebase_dev.DefaultFirebaseOptions.currentPlatform
        : firebase_prod.DefaultFirebaseOptions.currentPlatform;
    
    // Initialize Firebase with flavor-specific options
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
    
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Initialize Hive cache before dependency injection
    final cacheService = CacheService();
    await cacheService.init();

    await init(cacheService: cacheService);

    final storage = sl<AuthCubit>().storage;
    final token = await storage.read('accessToken');

    // Log flavor info in debug mode
    if (kDebugMode) {
      print('🚀 Running in ${FlavorConfig.instance.name.toUpperCase()} mode');
      print('📱 App Title: ${FlavorConfig.instance.title}');
      print('🌐 API Base URL: ${FlavorConfig.instance.apiBaseUrl}');
    }

    runApp(App(isLoggedIn: token != null));
  }, (error, stack) {
    // Catch errors that occur outside of the Flutter framework
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

