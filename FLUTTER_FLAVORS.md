# Flutter Flavors Documentation

## Overview

This project uses **Flutter Flavors** to manage different build configurations for development (DEV) and production (PROD) environments. Each flavor has its own Firebase project, API endpoints, and configuration.

## 📱 Flavors

### 1. **DEV (Development)**
- **Purpose**: Testing and development
- **App Name**: Dental Mobile DEV
- **Bundle ID (Android)**: `com.karamlyy.dental_mobile.dev`
- **Bundle ID (iOS)**: `com.karamlyy.dentalMobile.dev`
- **Firebase Project**: `dental-app-ef4ff-dev` (TODO: Create separate Firebase project)
- **API Base URL**: Configure in `lib/main_dev.dart`

### 2. **PROD (Production)**
- **Purpose**: Live production app
- **App Name**: Dental Mobile
- **Bundle ID (Android)**: `com.karamlyy.dental_mobile`
- **Bundle ID (iOS)**: `com.karamlyy.dentalMobile`
- **Firebase Project**: `dental-app-ef4ff`
- **API Base URL**: Configure in `lib/main_prod.dart`

## 🏗️ Project Structure

```
lib/
├── main.dart              # Main entry point (shared logic)
├── main_dev.dart          # DEV flavor entry point
├── main_prod.dart         # PROD flavor entry point
├── firebase_options.dart  # Original (can be deprecated)
├── firebase_options_dev.dart   # DEV Firebase config
├── firebase_options_prod.dart  # PROD Firebase config
└── config/
    └── flavor_config.dart      # Flavor configuration class

android/
└── app/
    ├── build.gradle.kts   # Android flavor configuration
    └── src/
        ├── dev/
        │   └── google-services.json   # DEV Firebase config
        └── prod/
            └── google-services.json   # PROD Firebase config

ios/
└── Runner/
    ├── GoogleService-Info-Dev.plist   # DEV Firebase config (TODO)
    └── GoogleService-Info-Prod.plist  # PROD Firebase config (TODO)
```

## 🚀 Running the App

### **DEV Flavor**

```bash
# Debug mode
flutter run --flavor dev -t lib/main_dev.dart

# Release mode
flutter run --release --flavor dev -t lib/main_dev.dart

# Build APK
flutter build apk --flavor dev -t lib/main_dev.dart

# Build AAB (for Play Store)
flutter build appbundle --flavor dev -t lib/main_dev.dart
```

### **PROD Flavor**

```bash
# Debug mode
flutter run --flavor prod -t lib/main_prod.dart

# Release mode
flutter run --release --flavor prod -t lib/main_prod.dart

# Build APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Build AAB (for Play Store)
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

## 🔧 Configuration

### FlavorConfig Class

The `FlavorConfig` class manages flavor-specific settings:

```dart
FlavorConfig.initialize(
  flavor: Flavor.dev,
  apiBaseUrl: 'https://your-dev-api-url.com',
);

// Access configuration
print(FlavorConfig.instance.name);        // 'dev' or 'prod'
print(FlavorConfig.instance.title);       // 'Dental Mobile DEV' or 'Dental Mobile'
print(FlavorConfig.instance.apiBaseUrl);  // API base URL
print(FlavorConfig.instance.isDev);       // true/false
print(FlavorConfig.instance.isProd);      // true/false
```

### Using Flavor Configuration

You can access the flavor configuration anywhere in your app:

```dart
import 'package:dental_mobile/config/flavor_config.dart';

// Check current flavor
if (FlavorConfig.instance.isDev) {
  // DEV-specific logic
  print('Running in DEV mode');
}

// Get API base URL
final apiUrl = FlavorConfig.instance.apiBaseUrl;
```

## 🔥 Firebase Setup

### Current Status

- ✅ **PROD**: Configured with existing Firebase project
- ⚠️ **DEV**: Using placeholder config (needs separate Firebase project)

### Setting Up DEV Firebase Project

1. **Create a new Firebase project** for development:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project (e.g., `dental-app-dev`)
   - Enable required services (Authentication, Firestore, Crashlytics, Analytics)

2. **Android Configuration**:
   ```bash
   # Download google-services.json for DEV
   # Place it in: android/app/src/dev/google-services.json
   ```

3. **iOS Configuration** (TODO):
   ```bash
   # Download GoogleService-Info.plist for DEV
   # Rename to GoogleService-Info-Dev.plist
   # Add to Xcode project with proper build configuration
   ```

4. **Update Firebase Options**:
   - Run FlutterFire CLI for DEV project:
   ```bash
   flutterfire configure --project=dental-app-dev --out=lib/firebase_options_dev.dart
   ```

## 📱 Android Configuration

### build.gradle.kts

The Android build configuration includes two product flavors:

```kotlin
flavorDimensions += "environment"
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "Dental Mobile DEV")
    }
    create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "Dental Mobile")
    }
}
```

### Features:
- ✅ **Separate App IDs**: Dev and Prod can be installed simultaneously
- ✅ **Different App Names**: Easy to distinguish in launcher
- ✅ **Separate Firebase Configs**: Each flavor uses its own `google-services.json`

## 📱 iOS Configuration (TODO)

iOS flavors need to be configured manually in Xcode:

1. **Create Build Configurations**:
   - Duplicate existing configurations
   - Rename to `Debug-dev`, `Release-dev`, `Debug-prod`, `Release-prod`

2. **Create Schemes**:
   - Create `dev` scheme using dev configurations
   - Create `prod` scheme using prod configurations

3. **Configure Bundle IDs**:
   - Set different bundle IDs per configuration
   - Dev: `com.karamlyy.dentalMobile.dev`
   - Prod: `com.karamlyy.dentalMobile`

4. **Add Firebase Config Files**:
   - Add both `GoogleService-Info-Dev.plist` and `GoogleService-Info-Prod.plist`
   - Configure build phases to copy the correct file based on configuration

## 🎯 Use Cases

### API Endpoints

Configure different API endpoints per flavor:

```dart
// lib/main_dev.dart
FlavorConfig.initialize(
  flavor: Flavor.dev,
  apiBaseUrl: 'https://dev-api.example.com',
);

// lib/main_prod.dart
FlavorConfig.initialize(
  flavor: Flavor.prod,
  apiBaseUrl: 'https://api.example.com',
);
```

Then use in your API clients:

```dart
final baseUrl = FlavorConfig.instance.apiBaseUrl;
```

### Environment-Specific Features

Enable/disable features based on flavor:

```dart
// Only show debug tools in DEV
if (FlavorConfig.instance.isDev) {
  showDebugTools();
}

// Different analytics tracking
if (FlavorConfig.instance.isProd) {
  enableProductionAnalytics();
}
```

## 🔍 Debugging

The app logs flavor information on startup (debug mode only):

```
🚀 Running in DEV mode
📱 App Title: Dental Mobile DEV
🌐 API Base URL: https://dev-api.example.com
```

## ✅ Benefits

1. **Separate Firebase Projects**
   - Independent data, analytics, and crashlytics
   - Test without affecting production

2. **Different API Endpoints**
   - Test against staging/dev servers
   - Production uses live servers

3. **Side-by-Side Installation**
   - Install both DEV and PROD on same device
   - Easy to compare and test

4. **Clear Visual Distinction**
   - Different app names
   - Easy to identify which environment you're using

5. **Safe Testing**
   - Test features without risk to production data
   - Separate user bases

## 🛠️ IDE Configuration (VS Code)

Add to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "Prod",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod"]
    }
  ]
}
```

## 🛠️ IDE Configuration (Android Studio)

1. **Run/Debug Configurations**
2. Click `+` → Flutter
3. Create two configurations:
   - **Dev**: Entry point: `lib/main_dev.dart`, Additional args: `--flavor dev`
   - **Prod**: Entry point: `lib/main_prod.dart`, Additional args: `--flavor prod`

## 📝 TODO

- [ ] Create separate Firebase project for DEV
- [ ] Update `firebase_options_dev.dart` with real DEV credentials
- [ ] Replace DEV `google-services.json` with actual DEV project file
- [ ] Configure iOS flavors in Xcode
- [ ] Add DEV Firebase config for iOS
- [ ] Update API base URLs in `main_dev.dart` and `main_prod.dart`
- [ ] Add environment-specific .env files if needed
- [ ] Configure CI/CD pipelines for both flavors

## 🚨 Important Notes

1. **Never commit sensitive keys** to version control
2. **Use separate Firebase projects** for DEV and PROD
3. **Always test both flavors** before release
4. **Keep flavor configurations in sync** between iOS and Android
5. **Document any flavor-specific behaviors** in code comments

## 📚 Resources

- [Flutter Flavors Guide](https://docs.flutter.dev/deployment/flavors)
- [Firebase Projects Best Practices](https://firebase.google.com/docs/projects/learn-more)
- [Android Product Flavors](https://developer.android.com/studio/build/build-variants)
