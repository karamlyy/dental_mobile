import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get baseUrl {

    //final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://stomcab.api';
    //return baseUrl;

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