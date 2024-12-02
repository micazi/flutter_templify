import 'dart:convert';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../../constants.dart';
import '../../helpers/error_helper.dart';
import '../../validators/file_path_provided.dart';
import '../../validators/template_data_provided.dart';
import '../../validators/templates_directory_exists.dart';

Future<void> addTemplateCallback(Map<String, dynamic>? args, Map<String, bool>? flags) async {
  // Path of the template
  String templateFilePath = args?['file'] ?? args?['f'];

  // Override if already exists?
  bool withOverwrite = flags?['overwrite'] ?? flags?['ow'] ?? false;

  // Make sure the templates directory exists...
  await ConsoleHelper.loadWithTask(task: 'Reading templates location...', process: () async => await validateTemplateDirectoryExists());

  // Make sure the the template file provided
  await ConsoleHelper.loadWithTask(task: 'Validating provided template...', process: () async => await validateFilePathProvided(templateFilePath));

  // Parse the provided yaml file...
  late Map<dynamic, YamlNode> map;
  await ConsoleHelper.loadWithTask(task: 'Parsing YAML file...', process: () async => await YamlModule.load(templateFilePath).then((v) => v.nodes).then((v) => map = v));

  // Check the provided Name and Description
  String? templateName = map['name']?.toString();
  String? templateDescription = map['description']?.toString();

  // Make sure name and description are provided...
  validateTemplateDataProvided(templateName, templateDescription);

  // Check to see if template already exists...
  if (await IOHelper.directory.exists("${Constants.envPath}/templates/$templateName")) {
    if (!withOverwrite) {
      ErrorHelper.print("Template with the same name already exists. If you want to overwrite it, use the '--overwrite | -ow' flag.");
      ConsoleHelper.exit(1);
    } else {
      ConsoleHelper.write("--> Overwriting the template...".withColor(ConsoleColor.red));
      ConsoleHelper.writeSpace();
    }
  }

  await ConsoleHelper.loadWithTask(
      task: 'Doing the templater magic...',
      process: () async {
        // Copy the yaml file to the templates directory
        await IOHelper.file.copy(
          templateFilePath,
          "${Constants.templatesPath}/$templateName/template.yaml",
        );

        // Create the template directory with the meta file
        File metaFile = await IOHelper.file.create("${Constants.envPath}/templates/$templateName/.meta", createFoldersInPath: true);
        String metaContent = jsonEncode({
          'currentVersion': '0.0.1',
          'last-accessed': DateTime.now().toIso8601String(),
          'storage': 'local',
          'storage-ref': '',
        });

        // Write the metadata to the .meta file
        await IOHelper.file.writeString(metaFile.path, metaContent);

        // Copy the src directory to the template if it exists.
        String templateDirectoryPath = templateFilePath.replaceAll('${Platform.pathSeparator}template.yaml', '');
        List<Directory> drs = await IOHelper.directory.listAll(templateDirectoryPath);
        if (drs.where((d) => d.path.split(Platform.pathSeparator).last == 'src').toList().isNotEmpty) {
          Directory srcD = drs.where((d) => d.path.split(Platform.pathSeparator).last == 'src').toList().first;
          await IOHelper.directory.copy(srcD.path, "${Constants.envPath}/templates/$templateName");
        }
      });

  // Feedback
  ConsoleHelper.write("${'All done!'.withColor(ConsoleColor.green)}\nCheck the new template with 'flutter_templify templates ${'ls'.withColor(ConsoleColor.blue)}'", newLine: true);
  ConsoleHelper.exit(0);
}
