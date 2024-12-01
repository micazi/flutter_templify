import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../helpers/error_helper.dart';

Future<void> validateFilePathProvided(String? templateFilePath) async {
  if (templateFilePath == null ||
      !await IOHelper.file.exists(templateFilePath) ||
      templateFilePath.split(Platform.pathSeparator).last != 'templater.yaml') {
    ErrorHelper.print(
        "You need to provide a valid path to the Template YAML File using '--file | -f' arguments, Also make sure it's called 'templater.yaml'.");
    ConsoleHelper.exit(1);
  }
}
