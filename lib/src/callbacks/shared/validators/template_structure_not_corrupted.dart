import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:path/path.dart' as p;
import '../../../constants.dart';
import '../../../helpers/prints_helper.dart';
import 'template_exists.dart';

Future<void> validateTemplateStructureIsNotCorrupted(
    String? templateName) async {
  // Make sure the template exists
  await validateTemplateExists(templateName);

  // Check if the directory has the template yaml.
  String templateDirPath = await IOHelper.directory
      .listAll(Constants.templatesPath!)
      .then((d) => d
          .where((dd) => p.basename(dd.absolute.path) == (templateName ?? ''))
          .toList()
          .map((dir) => dir.path)
          .toList()
          .first);
  List<String> templateFilePathes = await IOHelper.file
      .listAll(templateDirPath)
      .then((files) => files.map((file) => p.normalize(file.path)).toList());

  if (!templateFilePathes.any((f) =>
      f.replaceSeparator() ==
      "$templateDirPath${Platform.pathSeparator}$templateName.yaml"
          .replaceSeparator())) {
    PrintsHelper.printError(
        "Template $templateName is corrupted or has no configuration file. Remove it or update it's configuration file name to '$templateName.yaml'.");
    ConsoleHelper.exit(1);
  }
}
