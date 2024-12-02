import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../constants.dart';
import '../helpers/error_helper.dart';
import 'template_exists.dart';

Future<void> validateTemplateIsNotCorrupted(String? templateName) async {
  // Make sure the template exists
  await validateTemplateExists(templateName);

  // Check if the directory has the template yaml.
  Directory templateDir = await IOHelper.directory.listAll(Constants.templatesPath!).then((d) => d.where((dd) => dd.path.split(Platform.pathSeparator).last == (templateName ?? '')).toList().first);
  List<File> templateFiles = await IOHelper.file.listAll(templateDir.path);
  if (!templateFiles.any((f) => f.path == "${templateDir.path}/template.yaml")) {
    ErrorHelper.print("Template '${templateDir.path.split(Platform.pathSeparator).last}' is corrupted or has no configuration file. Remove it or update it's configuration file.");
    ConsoleHelper.exit(1);
  }
}
