import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/flavor_config.dart';
import 'main.dart' as app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Platform-specific base URL for DEV
  // Android Emulator: 10.0.2.2 maps to host machine's localhost
  // iOS Simulator: localhost works directly
  final devApiUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
  
  // Initialize DEV flavor
  FlavorConfig.initialize(
    flavor: Flavor.dev,
    apiBaseUrl: devApiUrl,
  );
  
  // Run the app
  app.main();
}
