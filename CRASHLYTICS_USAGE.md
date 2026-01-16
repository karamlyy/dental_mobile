# Firebase Crashlytics Integration

Firebase Crashlytics has been successfully integrated into the Dental Mobile app. This document explains how to use it.

## Setup Complete ✅

The following components have been configured:

1. ✅ **Dependencies**: Added `firebase_crashlytics: ^5.0.6` to `pubspec.yaml`
2. ✅ **Android Configuration**: Added Crashlytics Gradle plugin
3. ✅ **Main.dart**: Set up automatic crash reporting
4. ✅ **Helper Utility**: Created `CrashlyticsHelper` for easy usage

## Automatic Error Reporting

Crashlytics automatically captures:
- **Fatal Flutter errors** (framework errors)
- **Uncaught exceptions** (async errors)
- **Native crashes** (Android/iOS platform errors)

No additional code is needed for automatic reporting - it's already configured in `main.dart`.

## Manual Error Logging

Use the `CrashlyticsHelper` class for manual logging:

### 1. Log Errors

```dart
import 'package:dental_mobile/core/utils/crashlytics_helper.dart';

try {
  // Risky operation
  await fetchPatientData();
} catch (e, stackTrace) {
  // Log the error to Crashlytics
  await CrashlyticsHelper.logError(
    e,
    stackTrace,
    reason: 'Failed to fetch patient data',
    fatal: false,
  );
}
```

### 2. Log Custom Messages

```dart
// Log important app events
await CrashlyticsHelper.log('User logged in successfully');
await CrashlyticsHelper.log('Started appointment creation flow');
```

### 3. Set User Information

```dart
// Set user ID when user logs in
await CrashlyticsHelper.setUserId('doctor_123');

// Add custom context
await CrashlyticsHelper.setCustomKey('user_role', 'doctor');
await CrashlyticsHelper.setCustomKey('clinic_id', '456');
await CrashlyticsHelper.setCustomKey('app_language', 'az');
```

### 4. Use in Bloc/Cubit

Integrate Crashlytics in your state management:

```dart
class PatientsCubit extends Cubit<PatientsState> {
  Future<void> loadPatients() async {
    try {
      emit(PatientsLoading());
      final patients = await _api.getPatients();
      emit(PatientsLoaded(patients));
    } catch (e, stackTrace) {
      // Log error to Crashlytics
      await CrashlyticsHelper.logError(
        e,
        stackTrace,
        reason: 'Failed to load patients list',
      );
      
      emit(PatientsError(e.toString()));
    }
  }
}
```

### 5. Network Error Tracking

Track API errors:

```dart
class DioClient {
  Dio dio;

  DioClient(this.dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Log API errors to Crashlytics
          await CrashlyticsHelper.log(
            'API Error: ${error.requestOptions.path} - ${error.message}'
          );
          
          await CrashlyticsHelper.setCustomKey('api_endpoint', error.requestOptions.path);
          await CrashlyticsHelper.setCustomKey('status_code', error.response?.statusCode ?? 0);
          
          handler.next(error);
        },
      ),
    );
  }
}
```

## Testing Crashlytics

### Test Crash (Debug Only)

```dart
import 'package:flutter/foundation.dart';

// Only for testing in debug mode
if (kDebugMode) {
  CrashlyticsHelper.forceCrash();
}
```

### Test Error Logging

```dart
// Log a test error
await CrashlyticsHelper.logError(
  Exception('This is a test error'),
  StackTrace.current,
  reason: 'Testing Crashlytics integration',
);
```

### Verify in Firebase Console

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **dental-app-ef4ff**
3. Navigate to **Crashlytics** in the left menu
4. Wait 5-10 minutes for test crashes to appear

## Best Practices

### 1. Set User Context Early

In your `AuthCubit` after successful login:

```dart
class AuthCubit extends Cubit<AuthState> {
  Future<void> login(String email, String password) async {
    try {
      final response = await _api.login(email, password);
      
      // Set user context for Crashlytics
      await CrashlyticsHelper.setUserId(response.userId);
      await CrashlyticsHelper.setCustomKey('user_email', email);
      await CrashlyticsHelper.setCustomKey('user_role', response.role);
      
      emit(AuthSuccess(response));
    } catch (e, stackTrace) {
      await CrashlyticsHelper.logError(e, stackTrace, reason: 'Login failed');
      emit(AuthError(e.toString()));
    }
  }
}
```

### 2. Log Navigation Events

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        // Log screen views
        RouteObserver<PageRoute>()..subscribe(
          _CrashlyticsRouteObserver(), ModalRoute.of(context)!
        ),
      ],
    );
  }
}

class _CrashlyticsRouteObserver extends RouteObserver<PageRoute> {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      CrashlyticsHelper.log('Screen: ${route.settings.name}');
    }
  }
}
```

### 3. Track Critical User Actions

```dart
// Before critical operations
await CrashlyticsHelper.log('Creating new patient record');
await CrashlyticsHelper.setCustomKey('patient_creation_timestamp', DateTime.now().toIso8601String());

try {
  await createPatient(data);
  await CrashlyticsHelper.log('Patient created successfully');
} catch (e, stackTrace) {
  await CrashlyticsHelper.logError(e, stackTrace, reason: 'Patient creation failed');
}
```

### 4. Privacy Considerations

Don't log sensitive information:

```dart
// ❌ BAD - Don't log sensitive data
await CrashlyticsHelper.setCustomKey('password', userPassword);
await CrashlyticsHelper.setCustomKey('credit_card', cardNumber);

// ✅ GOOD - Log non-sensitive identifiers
await CrashlyticsHelper.setCustomKey('user_id', userId);
await CrashlyticsHelper.setCustomKey('patient_count', patientCount);
```

## Control Crashlytics Collection

### Disable in Development

```dart
// In main.dart or init()
if (kDebugMode) {
  await CrashlyticsHelper.setCrashlyticsCollectionEnabled(false);
}
```

### Check Previous Crash

```dart
final didCrash = await CrashlyticsHelper.didCrashOnPreviousExecution();
if (didCrash) {
  // Show user a message or take recovery action
  print('App crashed in previous session');
}
```

## Viewing Crashes

1. **Firebase Console**: https://console.firebase.google.com/project/dental-app-ef4ff/crashlytics
2. **Filter by**:
   - App version
   - Device type
   - Operating system
   - Time period
3. **View details**:
   - Stack trace
   - Custom keys
   - User ID
   - Logs leading up to crash

## Additional Resources

- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [Flutter Crashlytics Plugin](https://firebase.flutter.dev/docs/crashlytics/overview/)
- [Best Practices](https://firebase.google.com/docs/crashlytics/best-practices)

## Support

For issues or questions about Crashlytics integration, refer to:
- Firebase Console: https://console.firebase.google.com/
- Flutter Fire Documentation: https://firebase.flutter.dev/
