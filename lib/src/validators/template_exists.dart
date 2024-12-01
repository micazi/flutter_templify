import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../constants.dart';
import '../helpers/error_helper.dart';
import 'templates_directory_exists.dart';

Future<void> validateTemplateExists(String? templateName) async {
  // Make sure the templates directory is there.
  await validateTemplateDirectoryExists();

  // List all the folders in it.
  List<Directory> dirs =
      await IOHelper.directory.listAll(Constants.templatesPath!);

  // Check a match for the template's name
  bool tempExists = dirs
      .map((d) => d.path.split(Platform.pathSeparator).last)
      .where((dd) => dd == (templateName ?? ''))
      .isNotEmpty;

  if (!tempExists) {
    ErrorHelper.print("There's no templates with that name...");
    ConsoleHelper.exit(1);
  }
}
