import 'dart:io';
import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';
import '../../constants.dart';
import '../../helpers/prints_helper.dart';
import '../shared/validators/shared_validators.exports.dart';
import 'construct_create_command.dart';
import 'validators/prompt.dart';
import 'validators/prompt_result.dart';
import 'validators/supplied_prompts.dart';
import 'validators/template_provided.dart';
import 'create_structure.dart';

Future<void> createCallBack(String? templateName) async {
  // Make sure template is provided...
  validateTemplateIsProvided(templateName);

  // Make sure this template exists...
  await ConsoleHelper.loadWithTask(
      task: 'Making sure template exists...',
      process: () async => await validateTemplateExists(templateName));

  // Make sure this template is not corrupted...
  await ConsoleHelper.loadWithTask(
      task: 'Making sure template is not corrupted...',
      process: () async =>
          await validateTemplateStructureIsNotCorrupted(templateName));

  // Get the template's directory
  Directory templateDirectory = await IOHelper.directory
      .listAll(Constants.templatesPath!)
      .then((dirs) => dirs
          .where((dd) =>
              dd.path.split(Platform.pathSeparator).last ==
              (templateName ?? ''))
          .toList()
          .first);

  // Make sure the template is valid...
  await ConsoleHelper.loadWithTask(
      task: 'Making sure template is valid...',
      process: () async => await templateFileValid(
          "${templateDirectory.path}${Platform.pathSeparator}$templateName.yaml"));

  // Process template data from the YAML file...
  late Map<String, dynamic> parsedYamlMap;
  await ConsoleHelper.loadWithTask(
      task: 'Parsing the template structure...',
      process: () async =>
          await YamlModule.load("${templateDirectory.path}/$templateName.yaml")
              .then((v) => parsedYamlMap = YamlModule.extractData(v)));

  // Get the attributes from the parsed YAML map...
  // Section 1: General Information
  List<String> parsedPlatforms = (parsedYamlMap['platforms'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
      ["ios", "android"];
  bool parsedIsPackage = parsedYamlMap['isPackage'];
  // Section 2: Structure
  Map<String, dynamic> parsedStructure = parsedYamlMap['structure'];
  // Section 3: Project Creation
  Map<String, dynamic> parsedExtraPromptedVars =
      parsedYamlMap['extra_prompted_vars'] ?? {};
  List<String> parsedCustomCommands =
      (parsedYamlMap['custom_commands'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

  // Validate that supplied prompts are not main
  List<String> mainValues = ['project_name', 'domain_name'];
  validateSuppliedPrompts(parsedExtraPromptedVars, mainValues);

  // Default prompts...
  Map<String, dynamic> prompts = {
    'project_name': {
      'title': "Project Name",
      'description':
          "Name of the Project you're creating with a compatible structure, e.g new_flutter_project",
      'default': "new_flutter_project",
      'pattern': r'^[a-z]{1,}[a-z0-9_-]{0,}$',
    },
    'domain_name': {
      'title': "Domain Name",
      'description':
          "Name of the Organization's domain you're creating this project with e.g example.com",
      'default': "example.com",
      'pattern': r'^[a-zA-Z]{2,61}[a-zA-Z0-9-_]{0,}\.[a-zA-Z]{1,}$',
    },
  };

  // Add in the extra prompts...
  prompts = prompts..addEntries(parsedExtraPromptedVars.entries);

  // Go through the prompts and get the results...
  Map<String, String> promptResults = {};
  await Future.forEach(prompts.entries, (prompt) async {
    // Make sure the prompt is valid...
    validatePrompt(prompt);
    return await ConsoleHelper.getUserInput(
            defaultValue: prompt.value['default'],
            promptBuilder: (defValue, timeout) =>
                "[${prompt.value['title']}] ${prompt.value['description']} ${prompt.value['default'] == null ? '' : '(Defaults to `${prompt.value['default']}`): '}")
        .then((res) {
      if (res.isNotEmpty) {
        if ((prompt.value as Map).containsKey('pattern') &&
            prompt.value['pattern'] != null &&
            prompt.value['pattern'].toString().isNotEmpty) {
          // Validate the result to the pattern...
          validatePromptResult(
              res, prompt.value['pattern'], prompt.value['title']);
        }
        promptResults.addEntries([MapEntry(prompt.key, res)]);
      }
    });
  });

  // Main prompts results
  String projectName = promptResults['project_name']!;
  String domainName = promptResults['domain_name']!;

  // Give confirmation that I got the prompt results...
  await ConsoleHelper.loadWithTask(
      task: 'Getting prompt results...',
      process: () => Future.delayed(const Duration(seconds: 0)));

  // Create the project...
  ConsoleHelper.write("Creating project...".withColor(ConsoleColor.blue));
  ConsoleHelper.writeSpace();

  try {
    // Construct the CREATE command...
    String c = constructCreateCommand(
        isPackage: parsedIsPackage,
        platforms: parsedPlatforms,
        projectName: projectName,
        domain: domainName);

    // Get the Flutter SDK
    // String? flutterSDK = await getFlutterSdkPath();

    // Execute the CREATE command...
    await ConsoleHelper.executeCommand("flutter $c $projectName");
  } catch (e) {
    if (!e.toString().trim().contains(
        "The configured version of Java detected may conflict with the Gradle version in your new Flutter app.")) {
      PrintsHelper.printError(
          "Error while creating the project. ${e.toString().trim()}");
      ConsoleHelper.exit(1);
    }
  }
  await ConsoleHelper.loadWithTask(
      task: "Created the project successfully",
      process: () => Future.delayed(const Duration(seconds: 0)));

  // Create the Templated strucutre...
  await ConsoleHelper.loadWithTask(
      task: "Structuring your new project '$projectName'",
      process: () async {
        // Replicate the structure.
        String cwd = IOHelper.directory.getCurrent();
        await createStructure(
            parsedStructure,
            Directory('$cwd${Platform.pathSeparator}$projectName'),
            templateName!,
            promptResults);
      });

  // Execute the custom commands
  if (parsedCustomCommands.isNotEmpty) {
    // Get inside the project directory
    await IOHelper.directory.change('./$projectName'.replaceSeparator().trim());

    await Future.forEach(parsedCustomCommands, (command) async {
      // Pre-run print...
      ConsoleHelper.writeSpace();
      ConsoleHelper.write("Running '$command'".withColor(ConsoleColor.blue));
      ConsoleHelper.writeSpace();

      // Executing the command...
      try {
        await ConsoleHelper.executeCommand(command);
      } catch (e) {
        PrintsHelper.printError(
            "Error executing command. ${e.toString().trim()}");
        exit(1);
      }

      // Post-run print
      await ConsoleHelper.loadWithTask(
          task: "Running '$command' succeeded",
          process: () => Future.delayed(const Duration(seconds: 0)));
    });
  }

  // Feedback
  ConsoleHelper.write(
      "${'All done!'.withColor(ConsoleColor.green)}\n${'CD into your new project and check it out!'.withColor(ConsoleColor.magenta)}",
      newLine: true);
  ConsoleHelper.exit(0);
}
