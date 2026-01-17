import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/flavor_config.dart';
import 'main.dart' as app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize PROD flavor
  FlavorConfig.initialize(
    flavor: Flavor.prod,
    apiBaseUrl: dotenv.env['BASE_URL'] ?? 'https://api.stomcab.com',
  );
  
  // Run the app
  app.main();
}
