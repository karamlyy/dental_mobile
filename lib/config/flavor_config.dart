/// Flavor configuration for the app
enum Flavor {
  dev,
  prod,
}

/// Configuration class for managing app flavors
class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String title;
  final String apiBaseUrl;
  
  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.title,
    required this.apiBaseUrl,
  });

  static FlavorConfig? _instance;

  /// Get the current flavor configuration
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig has not been initialized. Call FlavorConfig.initialize() first.');
    }
    return _instance!;
  }

  /// Check if FlavorConfig is initialized
  static bool get isInitialized => _instance != null;

  /// Initialize the flavor configuration
  static void initialize({
    required Flavor flavor,
    required String apiBaseUrl,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: flavor.name,
      title: _getTitle(flavor),
      apiBaseUrl: apiBaseUrl,
    );
  }

  /// Get display title for flavor
  static String _getTitle(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return 'Dental Mobile (DEV)';
      case Flavor.prod:
        return 'Dental Mobile';
    }
  }

  /// Check if current flavor is dev
  bool get isDev => flavor == Flavor.dev;

  /// Check if current flavor is prod
  bool get isProd => flavor == Flavor.prod;

  @override
  String toString() {
    return 'FlavorConfig(flavor: $name, title: $title, apiBaseUrl: $apiBaseUrl)';
  }
}
