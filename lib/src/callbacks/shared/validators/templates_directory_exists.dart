import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../constants.dart';
import '../../../helpers/prints_helper.dart';

Future<void> validateTemplatesDirectoryExists() async {
  // Make sure that the ENV path is configured
  if (!Constants.envPathConfigured) {
    // Env path is not configured
    PrintsHelper.printError(
        "You haven't set the 'FLUTTER_TEMPLIFY_PATH' yet, please do so!");
    ConsoleHelper.exit(1);
  }

  if (!await IOHelper.directory.exists(Constants.templatesPath ?? '')) {
    await IOHelper.directory.create(Constants.templatesPath ?? '');
  }
}
