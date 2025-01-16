import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../../helpers/prints_helper.dart';

Future<void> validateFilePathProvided(String? templateFilePath) async {
  if (templateFilePath == null ||
      !await IOHelper.file.exists(templateFilePath)) {
    PrintsHelper.printError(
        "You need to provide a valid path to the Template YAML File using '--file | -f' arguments.");
    ConsoleHelper.exit(1);
  }
}
