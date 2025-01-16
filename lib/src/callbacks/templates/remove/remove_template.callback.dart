import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import '../../../constants.dart';
import '../../shared/validators/template_exists.dart';

Future<void> removeTemplateCallback(String? templateName) async {
  // Make sure the template exists...
  await ConsoleHelper.loadWithTask(
      task: "Making sure the template exists...",
      process: () => validateTemplateExists(templateName));

  // Delete the template
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
        await IOHelper.directory.delete(tempPath, recursive: true);
      });

  // Feedback
  ConsoleHelper.write(
      "${'✓'.withColor(ConsoleColor.green)} removed template successfully.");
  ConsoleHelper.exit(0);
}
