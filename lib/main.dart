import 'dart:async';
import 'package:dental_mobile/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/di.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await init();

    await dotenv.load(fileName: ".env");
    final storage = sl<AuthCubit>().storage;
    final token = await storage.read('accessToken');

    runApp(App(isLoggedIn: token != null));
  }, (error, stack) {
    // Catch errors that occur outside of the Flutter framework
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

