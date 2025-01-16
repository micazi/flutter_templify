import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../helpers/prints_helper.dart';

Future<void> validateZipFileIsProvided(String? filePath) async {
  if (filePath == null || !await IOHelper.file.exists(filePath)) {
    PrintsHelper.printError(
        "You need to provide a valid zip file path using '--file | -f' arguments.");
    ConsoleHelper.exit(1);
  }
}
