import 'dart:convert';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../../../constants.dart';
import '../../../helpers/prints_helper.dart';
import 'validators/file_path_provided.dart';
import '../../shared/validators/shared_validators.exports.dart';
import 'convert_relative_to_absolute.dart';
import 'package:path/path.dart' as p;

Future<void> addTemplateCallback(
    Map<String, dynamic>? args, Map<String, bool>? flags) async {
  // Required args
  String templateFilePath = args?['file'] ?? args?['f'];
  bool withOverwrite = flags?['overwrite'] ?? flags?['ow'] ?? false;

  // Make sure the templates directory exists...
  await ConsoleHelper.loadWithTask(
      task: 'Reading templates location...',
      process: () async => await validateTemplatesDirectoryExists());

  // Make sure the the template file provided
  await ConsoleHelper.loadWithTask(
      task: 'Validating provided template...',
      process: () async => await validateFilePathProvided(templateFilePath));

  // Load the provided yaml file...
  late Map<String, dynamic> parsedYamlMap;
  await ConsoleHelper.loadWithTask(
      task: 'Parsing the template YAML file...',
      process: () async {
        await templateFileValid(templateFilePath);
        YamlMap yamlMap = await YamlModule.load(templateFilePath);
        Map<String, dynamic> p = YamlModule.extractData(yamlMap);
        parsedYamlMap = p;
      });

  // Get the provided template Name.
  String templateName = parsedYamlMap['name'].toString();

  // Check to see if template already exists...
  if (await IOHelper.directory
      .exists("${Constants.templatesPath}/$templateName")) {
    if (!withOverwrite) {
      PrintsHelper.printError(
          "Template with the same name already exists. If you want to overwrite it, use the '--overwrite | -ow' flag.");
      ConsoleHelper.exit(1);
    } else {
      ConsoleHelper.writeSpace();
      ConsoleHelper.write("[!] ========> Overwriting the template..."
          .withColor(ConsoleColor.red));
      ConsoleHelper.writeSpace();
    }
  }

  await ConsoleHelper.loadWithTask(
      task: 'Doing the templater magic...',
      process: () async {
        // Create the Template SRC folder...
        Directory srcDir = await IOHelper.directory
            .create("${Constants.templatesPath}/$templateName/src");

        // Function to iterate over the map...
        String currentParentTrail = '.';
        Future<Map<String, dynamic>> mapValueToRelativePath(
            Map<String, dynamic> map, String srcDirectoryPath,
            {String? parentPath}) async {
          Map<String, dynamic> updatedMap = {};

          await Future.forEach(map.entries, (mapEntry) async {
            if (mapEntry.key.endsWith('/')) {
              //-> Folder Key

              if (mapEntry.value == null) {
                //-> Empty Folder
                updatedMap[mapEntry.key] = null;
              } else {
                //-> Non-Empty Folder
                // Loop through the nested map...
                currentParentTrail =
                    "$currentParentTrail${Platform.pathSeparator}${mapEntry.key}";
                Map<String, dynamic> nestedMap = await mapValueToRelativePath(
                    mapEntry.value, srcDirectoryPath,
                    parentPath: currentParentTrail);
                updatedMap[mapEntry.key] = nestedMap;
                currentParentTrail =
                    "$currentParentTrail${Platform.pathSeparator}..";
              }
            } else {
              //-> File Key
              if (mapEntry.value != null) {
                // Get the file path...
                String filePath = p.normalize(p.isAbsolute(
                        mapEntry.value.toString().replaceAll('abs:', ''))
                    ? File(mapEntry.value.toString().replaceAll('abs:', ''))
                        .absolute
                        .path
                    : File(await convertRelativeToAbsolute(
                            mapEntry.value.toString(),
                            p.dirname(templateFilePath)))
                        .absolute
                        .path);

                String destinationFilePath =
                    "$srcDirectoryPath/${currentParentTrail == '.' ? '' : currentParentTrail}/ref_${mapEntry.key}"
                        .replaceSeparator();

                // Copy the file to the SRC
                await IOHelper.file
                    .copy(filePath, p.normalize(destinationFilePath));

                //Set the relative path of the copiedFile
                String relPath =
                    "./src/${currentParentTrail == '.' ? '' : currentParentTrail.endsWith('..') ? "$currentParentTrail${Platform.pathSeparator}" : currentParentTrail}" +
                        "ref_${mapEntry.key}".replaceSeparator();

                updatedMap[mapEntry.key] = p.normalize(relPath);
              } else {
                updatedMap[mapEntry.key] = null;
              }
            }
          });

          return updatedMap;
        }

        // Get the updated structure map and rewrite to the YAML Map...
        Map<String, dynamic> pathedMap = await mapValueToRelativePath(
            (parsedYamlMap['structure'] as Map<String, dynamic>),
            srcDir.absolute.path);

        parsedYamlMap['structure'] = pathedMap;

        // Create the yaml file to the templates directory
        await IOHelper.file.writeString(
          "${Constants.templatesPath}/$templateName/$templateName.yaml",
          YamlModule.convertDartToYaml(parsedYamlMap),
        );

        // Create the meta file and add content...
        File metaFile = await IOHelper.file.create(
            "${Constants.envPath}/templates/$templateName/.meta",
            createFoldersInPath: true);
        String metaContent = jsonEncode({
          'last-accessed': DateTime.now().toIso8601String(),
          'storage': 'local',
          'storage-ref': '',
        });
        await IOHelper.file.writeString(metaFile.path, metaContent);
      });

  // Feedback
  ConsoleHelper.write(
      "${'All done!'.withColor(ConsoleColor.green)}\nCheck the new template with 'flutter_templify templates ${'ls'.withColor(ConsoleColor.blue)}'",
      newLine: true);
  ConsoleHelper.exit(0);
}
