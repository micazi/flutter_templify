import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../constants.dart';
import '../../shared/validators/template_exists.dart';
import 'open_folder.dart';

/// The main callback for the `templates open` subcommand.
Future<void> openTemplateCallback(String? templateName) async {
  // Make sure the template exists...
  await ConsoleHelper.loadWithTask(
      task: "Making sure the template exists...",
      process: () => validateTemplateExists(templateName));

  // Open the template path...
  await ConsoleHelper.loadWithTask(
      task: "Structuring and Opening...",
      process: () async {
        String tempPath = await IOHelper.directory
            .listAll(Constants.templatesPath!)
            .then((dirs) => dirs
                .where((dd) =>
                    (dd.path.split(Platform.pathSeparator).last) ==
                    (templateName ?? ''))
                .first
                .path);
        await openFolder(tempPath);
      });

  // Feedback
  ConsoleHelper.write(
      "${'✓'.withColor(ConsoleColor.green)} Opened template successfully.");
  ConsoleHelper.exit(0);
}
