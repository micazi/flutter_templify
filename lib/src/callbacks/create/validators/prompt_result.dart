import 'package:darted_cli/console_helper.dart';

import '../../../helpers/prints_helper.dart';

void ValidatePromptResult(
    String promptResult, String pattern, String titleValue) {
  if (!RegExp(pattern).hasMatch(promptResult)) {
    PrintsHelper.printError(
        "Invalid $titleValue '$promptResult', Make sure it matches the required pattern.");
    ConsoleHelper.exit(1);
  }
}
