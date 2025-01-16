import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';

import '../../../helpers/prints_helper.dart';

/// Validate the template file supplied.
Future<void> TemplateFileValid(String yamlFilePath) async {
  // Check the path...
  if (!await IOHelper.file.exists(yamlFilePath)) {
    PrintsHelper.printError('The provided path to the config file is invalid.');
    ConsoleHelper.exit(1);
  }

  // Get the content of the Yaml file
  final YamlMap yamlContent = await YamlModule.load(yamlFilePath);

  try {
    // Validate the content of the Yaml file against the schema.
    await YamlModule.validate(yamlContent, schema, yamlFilePath: yamlFilePath);
  } catch (e) {
    PrintsHelper.printError(
        'Error in validating the Yaml configuration file supplied. $e');
    ConsoleHelper.exit(1);
  }
}

final schema = YamlValidationSchema(
  fields: {
    // Section 1: General Information
    'name': FieldRule(
      type: YamlValueType.string,
      required: true,
    ),
    'version': FieldRule(
      type: YamlValueType.string,
      required: true,
      matchesPattern: RegExp(r'^\d+\.\d+\.\d+$'),
    ),
    'description': FieldRule(
      type: YamlValueType.string,
      required: true,
    ),
    'platforms': FieldRule(
      type: YamlValueType.list,
      required: false,
      allowedValues: ['android', 'ios', 'web', 'macos', 'windows', 'linux'],
    ),
    'isPackage': FieldRule(
      type: YamlValueType.bool,
      required: true,
    ),

    // Section 2: Template Structure
    'structure': FieldRule(
      type: YamlValueType.map,
      required: true,
      recursiveMapSchema: {
        RegExp(r'^.*\..*$'): FieldRule(
          // Matches keys with dots (e.g., development.env)
          required: false,
          type: YamlValueType.filePath,
        ),
        RegExp(r'^.*/$'): FieldRule(
          // Matches keys ending with '/' (e.g., lib/)
          required: false,
          type: YamlValueType.map,
        ),
      },
    ),

    // Section 3: Project Creation
    'extra_prompted_vars': FieldRule(
      type: YamlValueType.map,
      required: false,
      recursiveMapSchema: {
        RegExp(r'^[a-zA-Z0-9_-]+$'): FieldRule(
          required: false,
          type: YamlValueType.map,
          recursiveMapSchema: {
            RegExp('title'): FieldRule(
              required: true,
              type: YamlValueType.string,
            ),
            RegExp('description'): FieldRule(
              required: true,
              type: YamlValueType.string,
            ),
            RegExp('default'): FieldRule(
              required: false,
              type: YamlValueType.string,
            ),
            RegExp('pattern'): FieldRule(
              required: false,
              type: YamlValueType.string,
            ),
          },
        ),
      },
    ),
    'custom_commands': FieldRule(
      type: YamlValueType.list,
      required: false,
    ),
  },
);
