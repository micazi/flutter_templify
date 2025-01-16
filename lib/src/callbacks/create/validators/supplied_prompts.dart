import 'package:darted_cli/console_helper.dart';

import '../../../helpers/prints_helper.dart';

void ValidateSuppliedPrompts(
    Map<String, dynamic> map, List<String> mainValues) {
  for (var v in mainValues) {
    if (map.containsKey(v)) {
      PrintsHelper.printError(
          "The prompt '$v' is already supplied as a main prompt, Make sure to remove it from the `extra_prompted_vars` parameter.");
      ConsoleHelper.exit(1);
    }
  }
}
