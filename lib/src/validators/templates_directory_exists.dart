import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../constants.dart';
import '../helpers/error_helper.dart';
import 'env_path_configured.dart';

Future<void> validateTemplateDirectoryExists() async {
  // Make sure that the ENV path is configured
  if (!validateEnvPathConfigured()) {
    // Env path is not configured
    ErrorHelper.print(
        "You haven't set the 'FLUTTER_TEMPLATER_PATH' yet, please do so!");
    ConsoleHelper.exit(1);
  }

  String templatesDirectory = "${Constants.envPath}/templates";
  if (!await IOHelper.directory.exists(templatesDirectory)) {
    await IOHelper.directory.create(templatesDirectory);
  }
}
