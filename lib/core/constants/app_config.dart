import 'dart:io';
import 'package:flutter/foundation.dart';

/// Central place for runtime configuration.
///
/// Base URL resolution:
///   Web           → http://localhost:5000/api      (same machine)
///   iOS simulator → http://localhost:5000/api      (shares Mac network)
///   Android emu   → http://10.0.2.2:5000/api       (special alias for host)
///   Real device   → set DEV_HOST env or falls back to 10.0.2.2
///   Production    → pass --dart-define=API_BASE_URL=https://.../api
class AppConfig {
  AppConfig._();

  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (kIsWeb) return 'http://localhost:5000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5000/api';
    return 'http://localhost:5000/api'; // iOS simulator / macOS
  }
}
