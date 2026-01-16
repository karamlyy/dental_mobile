# Firebase Crashlytics - Setup Summary

## ✅ Completed Steps

### 1. Dependencies Added
- ✅ Added `firebase_crashlytics: ^5.0.6` to `pubspec.yaml`
- ✅ Ran `flutter pub get` successfully

### 2. Android Configuration
- ✅ Added Crashlytics Gradle plugin to `android/settings.gradle.kts`
- ✅ Applied plugin in `android/app/build.gradle.kts`

### 3. iOS Configuration
- ✅ Firebase Core is already configured
- ✅ Crashlytics will be automatically configured via CocoaPods

### 4. Application Code
- ✅ Updated `lib/main.dart` with:
  - Firebase initialization
  - Automatic error reporting
  - Zone-guarded execution
- ✅ Created `lib/core/utils/crashlytics_helper.dart` utility class
- ✅ Updated `lib/features/auth/presentation/cubit/auth_cubit.dart` with Crashlytics logging

### 5. Documentation
- ✅ Created `CRASHLYTICS_USAGE.md` with comprehensive usage guide

## 🔧 Next Steps (Required)

### For iOS Development:

```bash
cd ios
pod install
cd ..
```

This will install the Firebase Crashlytics iOS SDK via CocoaPods.

### Build and Run:

#### Android:
```bash
flutter clean
flutter pub get
flutter run
```

#### iOS:
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

## 🧪 Testing Crashlytics

### Test 1: Force a Test Crash (Debug Mode)

Add this temporary code to any screen (e.g., after login):

```dart
import 'package:flutter/foundation.dart';
import 'package:dental_mobile/core/utils/crashlytics_helper.dart';

// Add a test button
ElevatedButton(
  onPressed: () {
    if (kDebugMode) {
      CrashlyticsHelper.forceCrash();
    }
  },
  child: Text('Test Crash (Debug Only)'),
)
```

### Test 2: Log a Test Error

```dart
import 'package:dental_mobile/core/utils/crashlytics_helper.dart';

// Test error logging
ElevatedButton(
  onPressed: () async {
    await CrashlyticsHelper.logError(
      Exception('Test error from dental app'),
      StackTrace.current,
      reason: 'Testing Crashlytics integration',
    );
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Test error logged to Crashlytics')),
    );
  },
  child: Text('Log Test Error'),
)
```

### Test 3: Trigger a Real Crash

Add this code temporarily:

```dart
// This will throw an uncaught exception
ElevatedButton(
  onPressed: () {
    throw Exception('Intentional crash for testing');
  },
  child: Text('Trigger Exception'),
)
```

## 📊 Viewing Crashes

1. **Open Firebase Console**: 
   https://console.firebase.google.com/project/dental-app-ef4ff/crashlytics

2. **Wait 5-10 minutes** after a crash occurs

3. **Check the Dashboard**:
   - View crash-free users percentage
   - See crash details and stack traces
   - Filter by version, device, OS

## 📱 Production Recommendations

### 1. Disable Test Crashes in Production

The helper class already includes safety checks, but ensure test code is removed:

```dart
// ❌ Remove this before production
if (kDebugMode) {
  CrashlyticsHelper.forceCrash();
}
```

### 2. Monitor Key User Flows

Add logging to critical paths:

```dart
// Before critical operations
await CrashlyticsHelper.log('Creating patient appointment');
await CrashlyticsHelper.setCustomKey('appointment_type', type);

try {
  await createAppointment(data);
  await CrashlyticsHelper.log('Appointment created successfully');
} catch (e, stackTrace) {
  await CrashlyticsHelper.logError(
    e, 
    stackTrace, 
    reason: 'Appointment creation failed'
  );
  rethrow;
}
```

### 3. Set User Context After Login

Already implemented in `AuthCubit`:
- User ID is set after successful login/registration
- Custom keys include email, role, specialization
- Context is cleared on logout

### 4. Privacy Compliance

**Never log**:
- Passwords
- Payment information
- Personal health information (PHI)
- Social security numbers
- Other PII (Personally Identifiable Information)

**Safe to log**:
- User IDs (anonymized)
- Session IDs
- Error messages
- App state
- Navigation paths

## 🔍 Example Crash Report

When a crash occurs, you'll see:

```
Exception: Failed to load patients
Reason: Network request failed
Stack Trace: [full stack trace]

Custom Keys:
- user_id: doctor_123
- user_role: doctor
- screen: patients_list
- api_endpoint: /api/patients

Logs:
- User logged in successfully
- Navigated to patients screen
- Starting patients list fetch
- Network error occurred
```

## 📚 Integration Examples

### Already Integrated:
- ✅ `AuthCubit` - Login, registration, logout tracking

### Recommended for Integration:
- ⭐ `PatientsCubit` - Patient data operations
- ⭐ `AppointmentsCubit` - Appointment management
- ⭐ `DioClient` - Network error tracking
- ⭐ Navigation observers - Screen tracking

### Example for PatientsCubit:

```dart
import 'package:dental_mobile/core/utils/crashlytics_helper.dart';

class PatientsCubit extends Cubit<PatientsState> {
  Future<void> fetchPatients() async {
    emit(PatientsLoading());
    try {
      await CrashlyticsHelper.log('Fetching patients list');
      
      final patients = await api.getPatients();
      
      await CrashlyticsHelper.setCustomKey('patient_count', patients.length);
      await CrashlyticsHelper.log('Patients loaded: ${patients.length}');
      
      emit(PatientsLoaded(patients));
    } catch (e, stackTrace) {
      await CrashlyticsHelper.logError(
        e,
        stackTrace,
        reason: 'Failed to fetch patients',
      );
      
      emit(PatientsError(e.toString()));
    }
  }
}
```

## 🆘 Troubleshooting

### Crashes not appearing in Firebase Console?

1. **Wait longer**: It can take up to 10 minutes for crashes to appear
2. **Check internet connection**: Device must be online
3. **Verify Firebase project**: Ensure you're looking at the correct project
4. **Check collection is enabled**: 
   ```dart
   final enabled = await CrashlyticsHelper.isCrashlyticsCollectionEnabled();
   print('Crashlytics enabled: $enabled');
   ```

### Build errors on Android?

```bash
# Clean and rebuild
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Build errors on iOS?

```bash
# Clean pods and reinstall
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

## 📞 Support

- **Firebase Console**: https://console.firebase.google.com/project/dental-app-ef4ff
- **Documentation**: See `CRASHLYTICS_USAGE.md`
- **Flutter Fire**: https://firebase.flutter.dev/docs/crashlytics/overview/

---

**Setup completed on**: 2026-01-16  
**Firebase Project**: dental-app-ef4ff  
**Package Version**: firebase_crashlytics ^5.0.6
