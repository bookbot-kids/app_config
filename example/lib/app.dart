import 'package:app_config/app_config.dart';
import 'package:logger/logger.dart';
import 'package:cloud_logger/cloud_logger.dart';

extension AppConfig on App {
  static Future<void> init() async {
    final app = App.shared;

    // The default config is the production config and has all the config for the app.
    // Other modes (e.g. debug, profile) can override specific properties of this config.
    app.defaultConfig = {
      'azureMonitorWorkbookId': 'test_workbook_id',
      'azureMonitorSharedKey': 'test_workbook_key',
      'azureMonitorLogName': 'Bookbot App',
      'proxyUrl': 'https://proxy.activecampaign.com',
    };

    // The debug config will use the default config and specific properties that are overrided.
    app.debugConfig = {'url': 'https://www.google.com', 'property': 'happy'};

    // You can set different loggers for different modes.
    // For example in release mode this will use Azure Monitor for logging.
    // The default for debug is the Console logger.
    final config = app.config;
    final logOutput = AzureMonitorOutput(config);
    final logger = Logger(printer: CloudPrinter(), output: logOutput);

    // This would also check for crashes and send to logOutput
    app.setLogger(Mode.release, logger);

    // Now that the configs and logger are setup, everything else can be setup.
  }
}

void main() {
  AppConfig.init().then((value) => {
        // Can end the splash screen
      });
}
