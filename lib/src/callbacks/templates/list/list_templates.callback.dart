import 'dart:convert';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../../../constants.dart';
import '../../shared/validators/shared_validators.exports.dart';
import 'validators/templates_not_empty.dart';
import 'package:path/path.dart' as p;

Future<void> listTemplatesCallback() async {
  List<String> templatesMappedString = [];

  // Reading templates directory....
  List<Directory> dirs = [];
  await ConsoleHelper.loadWithTask(
      task: "Reading templates directory...",
      process: () async {
        // Make sure the templates directory exists...
        await validateTemplatesDirectoryExists();

        // Get the templates directories and make sure they're not empty...
        dirs = await IOHelper.directory.listAll(Constants.templatesPath!);
      });

  // Makeing sure templates are all valid...
  await ConsoleHelper.loadWithTask(
      task: "Makeing sure templates are all valid...",
      process: () async {
        // Make sure templates are not empty...
        validateTemplatesNotEmpty(dirs);

        // Loop the templates and map to the list...
        await Future.forEach(dirs, (d) async {
          String templateName = p.basename(d.absolute.path);

          // Check the template structure is not corrupted...
          await validateTemplateStructureIsNotCorrupted(templateName);

          // Validate the template yaml file...
          String yamlFilePath =
              "${d.absolute.path}/$templateName.yaml".replaceSeparator();
          await templateFileValid(yamlFilePath);

          // Get the Yaml
          YamlMap yamlMap = await YamlModule.load(yamlFilePath);
          Map<String, dynamic> parsedYaml = YamlModule.extractData(yamlMap);

          // Extract the data I need from the yaml...
          String tempName = parsedYaml['name'];
          String tempDesc = parsedYaml['description'] ?? 'N/A';
          String tempVersion = parsedYaml['version'] ?? 'N/A';
          bool tempIsPackage = parsedYaml['isPackage'] ?? 'N/A';

          // Get the Metadata file...
          Map<String, dynamic> metaFile = await IOHelper.file
              .readAsString("${d.path}/.meta")
              .then((v) => jsonDecode(v));

          // Extract the data I need from the meta file...
          String metatempStorage = metaFile['storage'] ?? 'local';

          // Map to the printable string...
          templatesMappedString.add(
              "- ${tempName.withColor(ConsoleColor.cyan)} ${'($metatempStorage/$tempVersion)'.withColor(ConsoleColor.blue)} ${tempIsPackage ? '[PACKAGE]'.withColor(ConsoleColor.lightYellow) : ''}: $tempDesc");
        });
      });

  // Print & Return
  ConsoleHelper.write("""
||==================================
||
|| Got these templates:-
||
|| ${templatesMappedString.reduce((a, b) => "$a\n|| $b")}
||
||==================================
""");

  ConsoleHelper.exit(0);
}
