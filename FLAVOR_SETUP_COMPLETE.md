# ✅ Flutter Flavors Setup - TAMAMLANDI

## 📱 Konfiqurasiya

### DEV Environment
- **Firebase Project**: `dental-app-dev-96fda` ✅
- **Android Package**: `com.karamlyy.dental_mobile.dev` ✅
- **iOS Bundle ID**: `com.karamlyy.dentalMobile.dev` ⚠️ (Manual setup needed)
- **App Name**: "Dental Mobile DEV"
- **API Base URL**:
  - Android: `http://10.0.2.2:3000`
  - iOS: `http://localhost:3000`

### PROD Environment
- **Firebase Project**: `dental-app-ef4ff` ✅
- **Android Package**: `com.karamlyy.dental_mobile` ✅
- **iOS Bundle ID**: `com.karamlyy.dentalMobile` ✅
- **App Name**: "Dental Mobile"
- **API Base URL**: `${dotenv.env['BASE_URL']}` or fallback to `https://api.stomcab.com`

## 🚀 İstifadə

### Android Emulator-da DEV Run Et
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### iOS Simulator-da DEV Run Et
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### PROD Run Et
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

## 📋 Konfiqurasiya Detalları

### ✅ Tamamlanan

1. **Firebase Projects**
   - ✅ DEV: `dental-app-dev-96fda` yaradıldı
   - ✅ PROD: `dental-app-ef4ff` mövcuddur

2. **Android Configuration**
   - ✅ `build.gradle.kts` - flavors konfiqurasiyası
   - ✅ `src/dev/google-services.json` - DEV Firebase config
   - ✅ `src/prod/google-services.json` - PROD Firebase config
   - ✅ Fərqli application IDs
   - ✅ Fərqli app adları

3. **Flutter Configuration**
   - ✅ `lib/firebase_options_dev.dart` - DEV Firebase options
   - ✅ `lib/firebase_options_prod.dart` - PROD Firebase options
   - ✅ `lib/main_dev.dart` - DEV entry point (platform-aware URLs)
   - ✅ `lib/main_prod.dart` - PROD entry point
   - ✅ `lib/config/flavor_config.dart` - Flavor management
   - ✅ Platform-specific API URLs (iOS/Android)

4. **VS Code**
   - ✅ `.vscode/launch.json` - Debug configurations

### ⚠️ Manual Setup Lazımdır (iOS)

iOS üçün Xcode-da manual konfiqurasiya lazımdır:

1. **Xcode-u aç**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Build Configurations yarat**
   - Project Settings → Info → Configurations
   - Duplicate "Debug" → "Debug-dev"
   - Duplicate "Debug" → "Debug-prod"
   - Duplicate "Release" → "Release-dev"
   - Duplicate "Release" → "Release-prod"

3. **Schemes yarat**
   - Product → Scheme → New Scheme → "dev"
   - Product → Scheme → New Scheme → "prod"
   - Hər scheme üçün müvafiq build configuration seç

4. **Bundle IDs konfiqurasiya et**
   - Runner → Signing & Capabilities
   - Debug-dev / Release-dev: `com.karamlyy.dentalMobile.dev`
   - Debug-prod / Release-prod: `com.karamlyy.dentalMobile`

5. **Firebase Config Files əlavə et**
   - DEV üçün GoogleService-Info.plist yüklə
   - GoogleService-Info-Dev.plist adlandır
   - Xcode-a əlavə et (dev configuration üçün)

## 🔥 Firebase Services

Hər iki proyektdə aktivləşdirmək lazımdır:

### DEV Project (`dental-app-dev-96fda`)
- [ ] Authentication
- [ ] Firestore Database
- [ ] Firebase Crashlytics
- [ ] Firebase Analytics

### PROD Project (`dental-app-ef4ff`)
- [x] Authentication (aktivdir)
- [x] Firestore Database (aktivdir)
- [x] Firebase Crashlytics (aktivdir)
- [x] Firebase Analytics (aktivdir)

## 🎯 Platform-Specific API URLs

### DEV
```dart
// Android Emulator
http://10.0.2.2:3000  // 10.0.2.2 → host machine localhost

// iOS Simulator
http://localhost:3000  // Direct localhost access
```

### PROD
```dart
// .env faylından
${dotenv.env['BASE_URL']}

// Fallback
https://api.stomcab.com
```

## 🧪 Test

### 1. Android DEV Test
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

**Yoxla**:
- ✅ App adı: "Dental Mobile DEV"
- ✅ Firebase initialize: `dental-app-dev-96fda`
- ✅ API URL: `http://10.0.2.2:3000`
- ✅ Console: "🚀 Running in DEV mode"

### 2. Android PROD Test
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

**Yoxla**:
- ✅ App adı: "Dental Mobile"
- ✅ Firebase initialize: `dental-app-ef4ff`
- ✅ API URL: .env faylından və ya fallback
- ✅ Console: "🚀 Running in PROD mode"

### 3. Side-by-Side Test
Hər iki flavor-u eyni cihazda quraşdır:

```bash
# DEV quraşdır
flutter install --flavor dev -t lib/main_dev.dart

# PROD quraşdır
flutter install --flavor prod -t lib/main_prod.dart
```

Launcher-də hər iki app görünməlidir.

## 📦 Build Commands

### DEV
```bash
# Debug APK
flutter build apk --flavor dev -t lib/main_dev.dart

# Release APK
flutter build apk --release --flavor dev -t lib/main_dev.dart

# App Bundle (Play Store)
flutter build appbundle --flavor dev -t lib/main_dev.dart
```

### PROD
```bash
# Debug APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Release APK
flutter build apk --release --flavor prod -t lib/main_prod.dart

# App Bundle (Play Store)
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

## 🎉 Fəaliyyətdə Olan Xüsusiyyətlər

- ✅ **Ayrı Firebase Proyektləri**: DEV və PROD data tamamilə ayrıdır
- ✅ **Platform-Aware URLs**: iOS və Android üçün düzgün localhost mapping
- ✅ **Side-by-Side Installation**: Hər iki app eyni cihazda
- ✅ **Fərqli App İkonları/Adları**: Vizual fərq aydındır
- ✅ **Automatic Configuration**: Flavor seçimi ilə avtomatik konfiqurasiya
- ✅ **Environment Variables**: PROD üçün .env dəstəyi

## 📚 Sənədlər

- `FLUTTER_FLAVORS.md` - Ətraflı guide
- `FLAVOR_SETUP_CHECKLIST.md` - Setup checklist
- `.vscode/launch.json` - VS Code run configs

## 🎊 Status: HAZIRDIR! 

Android üçün tam hazırdır və işləməyə başlaya bilərsiniz! 

iOS üçün manual Xcode setup lazımdır (yuxarıda təlimatlar).

---

**Son Yeniləmə**: 2026-01-16  
**Status**: ✅ Production Ready (Android)
