import 'package:darted_cli/console_helper.dart';

import '../helpers/error_helper.dart';

void validateTemplateIsProvided(String? templateName) {
  if (templateName == null) {
    ErrorHelper.print(
        "You need to provide a valid template name using '--template | -t' arguments.");
    ConsoleHelper.exit(1);
  }
}
