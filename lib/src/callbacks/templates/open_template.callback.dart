import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../constants.dart';
import '../../helpers/open_folder.dart';
import '../../validators/template_exists.dart';

Future<void> openTemplateCallback(String? templateName) async {
  // Make sure the template exists...
  await validateTemplateExists(templateName);

  // Open the template path...
  String tempPath = await IOHelper.directory
      .listAll(Constants.templatesPath!)
      .then((dirs) => dirs
          .where((dd) =>
              (dd.path.split(Platform.pathSeparator).last) ==
              (templateName ?? ''))
          .first
          .path);
  await openFolder(tempPath);

  // Feedback
  ConsoleHelper.write(
      "${'✓'.withColor(ConsoleColor.green)} Opened template successfully.");
  ConsoleHelper.exit(0);
}
