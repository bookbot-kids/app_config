library app_config;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:crash_report/crash_report.dart';
import 'package:singleton/singleton.dart';

enum Mode { debug, release, profile, web }

/// App handles the global configurations and variables that need to be accessed anywhere in the app
/// App is configured in your own app.dart and extends App e.g. `extension AppConfig on App`. See the example folder and app.dart in this package.
class App {
  factory App() => Singleton.lazy(() => App._privateConstructor());
  App._privateConstructor();
  static App shared = App();

  Map<String, dynamic> _config = {};

  Map<String, dynamic> defaultConfig = {};
  Map<String, dynamic> debugConfig = {};
  Map<String, dynamic> profileConfig = {};
  Map<String, dynamic> webConfig = {};
  Map<String, dynamic> flavorConfig = {};

  Logger _logger = Logger(
      printer: SimplePrinter(colors: false, printTime: true),
      output: ConsoleOutput());

  Map<String, dynamic> get config {
    if (_config.isEmpty) {
      _config = defaultConfig;

      if (kDebugMode) {
        _config.addAll(debugConfig);
      }

      if (kProfileMode) {
        _config.addAll(profileConfig);
      }

      if (kIsWeb) {
        _config.addAll(webConfig);
      }

      _config.addAll(flavorConfig);

      return _config;
    }

    return _config;
  }

  set config(Map<String, dynamic> value) {
    _config = value;
  }

  void reset() => _config = {};

  void setLogger(Mode mode, Logger logger, {bool ignoreChecking = false}) {
    _logger =
        mode == Mode.debug && (ignoreChecking || kDebugMode) ? logger : _logger;

    if (mode == Mode.release && (ignoreChecking || kReleaseMode)) {
      _logger = logger;
      CrashReport.init(_logger);
    }
    _logger = mode == Mode.profile && (ignoreChecking || kProfileMode)
        ? logger
        : _logger;
    _logger = mode == Mode.web && (ignoreChecking || kIsWeb) ? logger : _logger;
  }

  Logger get logger => _logger;

  Future<void> recordError(FlutterErrorDetails details,
      {bool Function(dynamic exception, dynamic stacktrace)? callback}) async {
    await CrashReport.shared.recordFlutterError(details, callback: callback);
  }

  void recordErrorInZoned(Function func,
      {bool Function(dynamic exception, dynamic stacktrace)? callback}) {
    CrashReport.shared.executeInZoned(func, callback: callback);
  }
}
