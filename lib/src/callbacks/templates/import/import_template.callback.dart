import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:path/path.dart' as p;

import '../../../constants.dart';
import '../../shared/validators/shared_validators.exports.dart';
import 'unarchive_zip_file.dart';
import 'zip_file_provided.dart';

ImportTemplateCallback(String? filePath) async {
  // Validate the file is supplied and exists...
  await validateZipFileIsProvided(filePath);

  // Make sure the templates directory exists...
  await ConsoleHelper.loadWithTask(
      task: 'Reading templates location...',
      process: () async => validateTemplatesDirectoryExists());

  // Unarchive the file in the templates directory...
  String templateName = p.basenameWithoutExtension(filePath!);
  await ConsoleHelper.loadWithTask(
      task: 'Unarchiving the zip file...',
      process: () async => unarchiveZipFile(filePath,
          "${Constants.templatesPath!}${Platform.pathSeparator}$templateName"));

  // Make sure the template is valid...
  await ConsoleHelper.loadWithTask(
      task: 'Validating the imported template...',
      process: () async {
        // Check the template structure is not corrupted...
        await validateTemplateStructureIsNotCorrupted(templateName);

        // Validate the template yaml file...
        String yamlFilePath =
            "${Constants.templatesPath!}${Platform.pathSeparator}$templateName${Platform.pathSeparator}$templateName.yaml"
                .replaceSeparator();
        await TemplateFileValid(yamlFilePath);
      });
}
