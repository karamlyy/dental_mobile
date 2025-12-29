import 'dart:io';

class AppConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android Emulator üçün
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      // iOS Simulator üçün
      return 'http://localhost:3000';
    } else {
      return 'http://localhost:3000';
    }
  }
}