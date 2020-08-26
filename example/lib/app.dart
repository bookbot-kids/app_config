import 'package:app_config/app_config.dart';
import 'package:logger/logger.dart';
import 'package:cloud_logger/cloud_logger.dart';

extension AppConfig on App {
  static void initialise() {
    final app = App.shared;

    // The default config is the production config and has all the config for the app.
    // Other modes (e.g. debug, profile) can override specific properties of this config.
    app.defaultConfig = {
      'azureMonitorWorkbookId': '77344-dshdhd-3737-dhdhe-363564',
      'azureMonitorSharedKey': 'hgdshjsj-36363-dshdhe-26474-xnzowd',
      'azureMonitorLogName': 'Bookbot App'
    };

    // The debug config will use the default config and specific properties that are overrided.
    app.debugConfig = {'url': 'https://www.google.com', 'property': 'happy'};

    // You can set different loggers for different modes.
    // For example in release mode this will use Azure Monitor for logging
    final logOutput = AzureMonitorOutput(app.config);
    app.setLogger(
        Mode.release, Logger(printer: CloudPrinter(), output: logOutput));
  }
}

void main() {
  AppConfig.initialise();
}