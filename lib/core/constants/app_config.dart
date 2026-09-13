import 'package:flutter/foundation.dart';

/// Central place for runtime configuration.
///
/// Base URL resolution:
///   --dart-define=API_BASE_URL=https://.../api → used as-is (production)
///   --dart-define=DEV_HOST=192.168.1.5         → http://192.168.1.5:5000/api
///   Android emulator                           → http://10.0.2.2:5000/api
///   Web / iOS simulator / desktop              → http://localhost:5000/api
class AppConfig {
  AppConfig._();

  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL');
  static const String _devHost = String.fromEnvironment('DEV_HOST');

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (_devHost.isNotEmpty) return 'http://$_devHost:5000/api';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://localhost:5000/api';
  }
}
