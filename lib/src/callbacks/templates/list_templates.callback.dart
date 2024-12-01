import 'dart:convert';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../../constants.dart';
import '../../validators/template_not_corrupted.dart';
import '../../validators/templates_directory_exists.dart';
import '../../validators/templates_not_empty.dart';

Future<void> listTemplatesCallback() async {
  // Check that the templates directory exists...
  await validateTemplateDirectoryExists();

  // Get the templates directories and make sure they're not empty...
  List<Directory> dirs =
      await IOHelper.directory.listAll(Constants.templatesPath!);
  await validateTemplatesNotEmpty(dirs);

  // Loop the templates and map to the list...
  List<String> templatesMappedString = [];
  await Future.forEach(dirs, (d) async {
    // Check the template is not corrupted...
    validateTemplateIsNotCorrupted(d.path.split(Platform.pathSeparator).last);

    // Get the Yaml
    Map<dynamic, YamlNode> yamlMap = await YamlModule.load(
            "${d.path}${Platform.pathSeparator}templater.yaml")
        .then((v) => v.nodes);
    String tempName = yamlMap['name']?.value;
    String tempDesc = yamlMap['description']?.value ?? 'N/A';

    // Get the Metadata
    Map<String, dynamic> metaFile = await IOHelper.file
        .readAsString("${d.path}/.meta")
        .then((v) => jsonDecode(v));

    String tempVersion = metaFile['currentVersion'] ?? '0.0.1';
    String tempStorage = metaFile['storage'] ?? 'local';

    // Map to the printable string...
    templatesMappedString.add(
        "- ${tempName.withColor(ConsoleColor.cyan)} ${'($tempStorage/$tempVersion)'.withColor(ConsoleColor.blue)}: $tempDesc");
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
