import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../constants.dart';
import '../../shared/validators/template_exists.dart';
import 'archive_folder.dart';

/// The main callback for the `templates export` subcommand.
Future<void> exportTemplateCallback(
    String? templateName, String? outputDirectoryPath) async {
  // Make sure the template exists...
  await ConsoleHelper.loadWithTask(
      task: "Making sure the template exists...",
      process: () => validateTemplateExists(templateName));

  // Archive the template
  String filePath = (outputDirectoryPath ?? IOHelper.directory.getCurrent()) +
      Platform.pathSeparator +
      '$templateName.zip';
  await ConsoleHelper.loadWithTask(
      task: "Archiving the template folder...",
      process: () async {
        String tempPath = await IOHelper.directory
            .listAll(Constants.templatesPath!)
            .then((dirs) => dirs
                .where((dd) =>
                    (dd.path.split(Platform.pathSeparator).last) ==
                    (templateName ?? ''))
                .first
                .path);
        await archiveFolder(
          tempPath,
          filePath,
        );
      });

  // Feedback
  ConsoleHelper.writeSpace();
  ConsoleHelper.write(
      "archived template successfully, See the archive file at ${filePath.withColor(ConsoleColor.magenta)}"
          .withColor(ConsoleColor.green));
  ConsoleHelper.exit(0);
}
