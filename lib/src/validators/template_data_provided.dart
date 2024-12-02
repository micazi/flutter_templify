import 'package:darted_cli/console_helper.dart';

import '../helpers/error_helper.dart';
import 'template_name.dart';

void validateTemplateDataProvided(
    String? templateName, String? templateDescription) {
  if (templateName == null || templateDescription == null) {
    ErrorHelper.print(
        "You need to provide the name of the template and it's description through the 'template.yaml' file.");
    ConsoleHelper.exit(1);
  }
  validateTemplateName(templateName!);
}
