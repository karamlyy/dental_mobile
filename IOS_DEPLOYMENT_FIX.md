# iOS Deployment Target Fix

## Issue Resolved ✅

**Problem**: CocoaPods couldn't find compatible versions because Firebase SDK 12.6.0 required a higher minimum deployment target.

**Solution**: Updated iOS minimum deployment target from 13.0 to 15.0

## Changes Made

### 1. Updated `ios/Podfile`
- Changed platform from `ios, '13.0'` to `ios, '15.0'`
- Added deployment target enforcement in `post_install` block

```ruby
platform :ios, '15.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
```

### 2. Updated `ios/Flutter/AppFrameworkInfo.plist`
- Changed MinimumOSVersion from `13.0` to `15.0`

## Pod Installation Result ✅

Successfully installed 20 pods including:
- ✅ Firebase 12.6.0
- ✅ FirebaseCore 12.6.0
- ✅ FirebaseCrashlytics 12.6.0
- ✅ firebase_core 4.3.0
- ✅ firebase_crashlytics 5.0.6

## iOS Version Requirements

Your app now requires:
- **Minimum iOS Version**: 15.0
- **Deployment Target**: iOS 15.0+

### Device Compatibility

iOS 15.0 is compatible with:
- iPhone 6s and later
- iPad (5th generation) and later
- iPad Air 2 and later
- iPad mini 4 and later
- iPad Pro (all models)
- iPod touch (7th generation)

Released: September 20, 2021

## Next Steps

1. ✅ Pod install completed successfully
2. ✅ Firebase Crashlytics is ready
3. Build your app:

```bash
cd /Users/karamafandi/StudioProjects/dental_mobile
flutter run
```

## Testing

Test on iOS Simulator or device:

```bash
# List available iOS simulators
flutter devices

# Run on iOS
flutter run -d <device_id>
```

## Note About Warning

The CocoaPods warning about base configuration is normal for Flutter projects and does not affect functionality:

```
[!] CocoaPods did not set the base configuration of your project...
```

This is expected behavior and you can safely ignore it.

## Verification

To verify Crashlytics is working on iOS:

1. Run the app on iOS simulator/device
2. Trigger a test error (see `CRASHLYTICS_README.md`)
3. Check Firebase Console after 5-10 minutes

---

**Fixed on**: January 16, 2026  
**iOS Deployment Target**: 15.0  
**Firebase SDK Version**: 12.6.0  
**Status**: ✅ Ready to build and run
