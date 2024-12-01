import '../helpers/error_helper.dart';

void validateTemplateName(String templateName) async {
  if (templateName.contains(' ') || templateName.startsWith(RegExp(r'\d'))) {
    ErrorHelper.print(
        "Template name shouldn't start with a digit, and No spaces...");
  }
}
