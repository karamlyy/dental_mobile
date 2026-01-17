# Flutter Flavors Setup Checklist

## ✅ Completed Setup

- [x] Created flavor configuration class (`FlavorConfig`)
- [x] Created dev and prod entry points (`main_dev.dart`, `main_prod.dart`)
- [x] Created separate Firebase options files
- [x] Configured Android flavors in `build.gradle.kts`
- [x] Created directories for flavor-specific google-services.json
- [x] Updated main.dart to support flavors
- [x] Updated app.dart to use flavor-specific title
- [x] Created VS Code launch configurations
- [x] Created comprehensive documentation

## 🚨 IMPORTANT: Next Steps (TODO)

### 1. Create DEV Firebase Project

**Current Status**: DEV flavor is using placeholder Firebase configuration.

**Action Required**:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project called `dental-app-dev` (or similar)
3. Enable these services:
   - ✅ Authentication
   - ✅ Firestore Database
   - ✅ Firebase Crashlytics
   - ✅ Firebase Analytics

### 2. Update Android DEV Firebase Config

**File**: `android/app/src/dev/google-services.json`

**Action Required**:
1. In Firebase Console, go to Project Settings
2. Add Android app with package name: `com.karamlyy.dental_mobile.dev`
3. Download the `google-services.json` file
4. Replace `android/app/src/dev/google-services.json` with the downloaded file

### 3. Update DEV Firebase Options

**File**: `lib/firebase_options_dev.dart`

**Action Required**:
1. Install FlutterFire CLI if not already installed:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Generate Firebase options for DEV project:
   ```bash
   flutterfire configure \
     --project=dental-app-dev \
     --out=lib/firebase_options_dev.dart \
     --platforms=android,ios,web
   ```

### 4. Update API Base URLs

**Files**: 
- `lib/main_dev.dart` (line 10)
- `lib/main_prod.dart` (line 10)

**Action Required**:
```dart
// In main_dev.dart
FlavorConfig.initialize(
  flavor: Flavor.dev,
  apiBaseUrl: 'https://your-actual-dev-api-url.com', // ← Update this
);

// In main_prod.dart
FlavorConfig.initialize(
  flavor: Flavor.prod,
  apiBaseUrl: 'https://your-actual-prod-api-url.com', // ← Update this
);
```

### 5. Configure iOS Flavors (Optional but Recommended)

**Action Required**: Follow the iOS configuration steps in `FLUTTER_FLAVORS.md`

This includes:
- Creating Xcode schemes
- Setting up different bundle IDs
- Adding flavor-specific Firebase config files

### 6. Test Both Flavors

**Action Required**:
```bash
# Test DEV flavor
flutter run --flavor dev -t lib/main_dev.dart

# Test PROD flavor
flutter run --flavor prod -t lib/main_prod.dart
```

Verify:
- ✅ Correct app name appears
- ✅ Firebase is properly initialized
- ✅ API calls use correct base URL
- ✅ Both apps can be installed simultaneously

### 7. Update Environment Variables

**Action Required**: If using different API keys or secrets per environment:

Create flavor-specific .env files:
- `.env.dev`
- `.env.prod`

Update code to load the correct .env file based on flavor.

## 📝 Quick Reference

### Run Commands

```bash
# DEV
flutter run --flavor dev -t lib/main_dev.dart

# PROD
flutter run --flavor prod -t lib/main_prod.dart
```

### Build Commands

```bash
# DEV APK
flutter build apk --flavor dev -t lib/main_dev.dart

# PROD APK
flutter build apk --flavor prod -t lib/main_prod.dart

# DEV AAB (Play Store)
flutter build appbundle --flavor dev -t lib/main_dev.dart

# PROD AAB (Play Store)
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

## 🎯 Priority Actions

1. **HIGH**: Create DEV Firebase project and update configurations
2. **HIGH**: Update API base URLs in main_dev.dart and main_prod.dart
3. **MEDIUM**: Configure iOS flavors (if building for iOS)
4. **LOW**: Set up environment-specific .env files

## 📚 Documentation

For detailed information, see:
- `FLUTTER_FLAVORS.md` - Complete flavors documentation
- `.vscode/launch.json` - VS Code run configurations

## ℹ️ Current Status

**Android**: ✅ Fully configured  
**iOS**: ⚠️ Needs manual configuration  
**Firebase DEV**: ⚠️ Needs separate project  
**API URLs**: ⚠️ Need to be updated  

---

Once you complete these steps, your app will have fully functional dev and prod environments! 🚀
