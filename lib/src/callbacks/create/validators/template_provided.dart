import 'package:darted_cli/console_helper.dart';

import '../../../helpers/prints_helper.dart';

void validateTemplateIsProvided(String? templateName) {
  if (templateName == null) {
    PrintsHelper.printError(
        "You need to provide a valid template name using '--template | -t' arguments.");
    ConsoleHelper.exit(1);
  }
}
