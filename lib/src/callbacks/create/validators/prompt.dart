import 'package:darted_cli/console_helper.dart';

import '../../../helpers/helpers.exports.dart';

void ValidatePrompt(MapEntry prompt) {
  if (prompt.value is! Map ||
      (prompt.value as Map).isEmpty ||
      !(prompt.value as Map).containsKey('title') ||
      !(prompt.value as Map).containsKey('description') ||
      prompt.value['title'] is! String ||
      prompt.value['description'] is! String) {
    PrintsHelper.printError(
        "The supplied prompt '${prompt.key}' is not valid.");
    ConsoleHelper.exit(1);
  }
}
