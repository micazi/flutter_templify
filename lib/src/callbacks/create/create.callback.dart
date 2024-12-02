import 'dart:io';

import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../../constants.dart';
import '../../helpers/error_helper.dart';
import '../../validators/template_exists.dart';
import '../../validators/template_not_corrupted.dart';
import '../../validators/template_provided.dart';
import 'create_structure.dart';
import 'validate_references.dart';

Future<void> createCallBack(String? templateName, String projectName) async {
  // Make sure template is provided...
  validateTemplateIsProvided(templateName);

  // Make sure this template exists...
  await ConsoleHelper.loadWithTask(task: 'Making sure template exists...', process: () async => await validateTemplateExists(templateName));

  // Make sure this template is not corrupted
  await ConsoleHelper.loadWithTask(task: 'Making sure template is not corrupted...', process: () async => await validateTemplateIsNotCorrupted(templateName));

  // Get the template's directory
  Directory templateDirectory =
      await IOHelper.directory.listAll(Constants.templatesPath!).then((dirs) => dirs.where((dd) => dd.path.split(Platform.pathSeparator).last == (templateName ?? '')).toList().first);

  // Process template data from the YAML file...
  late Map<dynamic, YamlNode> yamlMap;
  await ConsoleHelper.loadWithTask(
      task: 'Parsing the template structure...', process: () async => await YamlModule.load("${templateDirectory.path}/template.yaml").then((v) => v.nodes).then((vv) => yamlMap = vv));

  String? yamlDomain = yamlMap['domain']?.value;
  YamlList? yamlPlatforms = yamlMap['platforms']?.value;
  YamlList? yamlStructure = yamlMap['structure']?.value;
  bool yamlIsPackage = yamlMap['isPackage']?.value ?? false;

  // Validate for not having a folder structure...
  if (yamlStructure == null) {
    ErrorHelper.print("Folder structure is not present, are you sure you need flutter_templify?");
    exit(1);
  }

  // Validate references in the structure...
  String? invalidReference;
  await ConsoleHelper.loadWithTask(
      task: 'Making sure reference files are all there...', process: () async => await validateReferencesInStructure(yamlStructure, templateName!).then((v) => invalidReference = v));
  if (invalidReference != null) {
    ErrorHelper.print("The file reference '$invalidReference' is invalid.");
    exit(1);
  }

  // Get the current wd...
  String cwd = IOHelper.directory.getCurrent();

  // Create the project's structure...
  await ConsoleHelper.loadWithTask(
      task: 'Doing the templater magic (aka creating structure)...',
      process: () async {
        // Create the project.
        String platforms = '';
        if (yamlPlatforms != null && !yamlIsPackage) {
          if (yamlPlatforms.contains('android')) platforms += '--platforms android ';
          if (yamlPlatforms.contains('ios')) platforms += '--platforms ios ';
          if (yamlPlatforms.contains('web')) platforms += '--platforms web ';
          if (yamlPlatforms.contains('windows')) platforms += '--platforms windows ';
          if (yamlPlatforms.contains('linux')) platforms += '--platforms linux ';
          if (yamlPlatforms.contains('macos')) platforms += '--platforms macos ';
        }

        String flutterCreateCommand =
            'flutter create ${yamlIsPackage ? '-t package ' : ''} ${yamlDomain != null ? '--org ${yamlDomain.split('.').reversed.join('.')}' : ''} $platforms --project-name $projectName $cwd${Platform.pathSeparator}$projectName';

        try {
          await ConsoleHelper.executeCommand(flutterCreateCommand);
        } catch (e) {
          ErrorHelper.print("${e.toString().trim()}");
          exit(1);
        }

        // Replicate the structure.
        await createStructure(yamlStructure, Directory('$cwd${Platform.pathSeparator}$projectName'), templateName!);
      });

  // Change to the project's directory
  await IOHelper.directory.change("$cwd/$projectName");

  // Run pub get
  await ConsoleHelper.loadWithTask(
      task: 'Running pub get...',
      process: () async {
        try {
          await ConsoleHelper.executeCommand("flutter pub get");
        } catch (e) {
          if (e is ConsoleException) {
            ErrorHelper.print("${e.error}");
            exit(1);
          }
        }
      });

  // Feedback
  ConsoleHelper.write("${'All done!'.withColor(ConsoleColor.green)}\n${'CD into your new project and check it out!'.withColor(ConsoleColor.magenta)}", newLine: true);
  ConsoleHelper.exit(0);
}
