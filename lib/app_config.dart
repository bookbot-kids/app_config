library app_config;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:crash_report/crash_report.dart';

enum Mode { debug, release, profile, web }

/// App handles the global configurations and variables that need to be accessed anywhere in the app
/// App is configured in your own app.dart and extends App e.g. `extension AppConfig on App`. See the example folder and app.dart in this package.
class App {
  App._privateConstructor();
  static App shared = App._privateConstructor();

  Map<String, dynamic> _config = {};

  Map<String, dynamic> defaultConfig = {};
  Map<String, dynamic> debugConfig = {};
  Map<String, dynamic> profileConfig = {};
  Map<String, dynamic> webConfig = {};
  Map<String, dynamic> flavorConfig = {};

  Logger _logger = Logger(printer: SimplePrinter(), output: ConsoleOutput());

  Map<String, dynamic> get config {
    WidgetsFlutterBinding.ensureInitialized();
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

  void reset() => _config = {};

  void setLogger(Mode mode, Logger logger) {
    _logger = mode == Mode.debug && kDebugMode ? logger : _logger;

    if (mode == Mode.release && kReleaseMode) {
      _logger = logger;
      CrashReport.init(logger);
    }
    _logger = mode == Mode.profile && kProfileMode ? logger : _logger;
    _logger = mode == Mode.web && kIsWeb ? logger : _logger;
  }

  Logger get logger => _logger;

  Future<void> recordError(FlutterErrorDetails details) async {
    await CrashReport.shared.recordFlutterError(details);
  }

  void recordErrorInZoned(Function func) {
    CrashReport.shared.executeInZoned(func);
  }
}
