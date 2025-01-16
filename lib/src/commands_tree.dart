import 'package:darted_cli/darted_cli.dart';
import './callbacks/callbacks.exports.dart';
import 'helpers/extensions.dart';

List<DartedCommand> commandsTree = [
  //S1 - Templates
  DartedCommand(
    name: 'templates',
    helperDescription: "Working with the custom templates.",
    flags: [DartedFlag.help.copyWith(appliedByDefault: true)],
    callback: (args, flags) async => () {},
    subCommands: [
      //S2 -- List
      DartedCommand(
        name: 'ls',
        helperDescription: "List all the templates saved.",
        flags: [
          DartedFlag.help,
        ],
        callback: (args, flags) async => await listTemplatesCallback(),
      ),
      //S2 -- Add
      DartedCommand(
        name: 'add',
        helperDescription: "Add a new custom template from a YAML file.",
        arguments: [
          DartedArgument(
              name: 'file',
              abbreviation: 'f',
              isMultiOption: false,
              description:
                  'path of the YAML file that represents your template.'),
        ],
        flags: [
          DartedFlag.help,
          DartedFlag(
              name: 'overwrite',
              abbreviation: 'ow',
              canBeNegated: false,
              appliedByDefault: false,
              description:
                  'overwrite the current template with the same name if exists.'),
        ],
        callback: (args, flags) async => await addTemplateCallback(args, flags),
      ),
      //S2 -- Open
      DartedCommand(
        name: 'open',
        helperDescription: "Open the template's containing folder to modify.",
        arguments: [
          DartedArgument(
              name: 'name',
              abbreviation: 'n',
              isMultiOption: false,
              description: 'name of the template to open.'),
        ],
        flags: [
          DartedFlag.help,
        ],
        callback: (args, flags) async =>
            await openTemplateCallback(args?['name'] ?? args?['n']),
      ),
      //S2 -- Remove
      DartedCommand(
        name: 'rm',
        helperDescription: "Remove a template.",
        arguments: [
          DartedArgument(
              name: 'name',
              abbreviation: 'n',
              isMultiOption: false,
              description: 'name of the template to remove.'),
        ],
        flags: [
          DartedFlag.help,
        ],
        callback: (args, flags) async =>
            await removeTemplateCallback(args?['name'] ?? args?['n']),
      ),
      //S2 -- Export
      DartedCommand(
        name: 'export',
        helperDescription: "Archive and Export a template for sharing.",
        arguments: [
          DartedArgument(
              name: 'name',
              abbreviation: 'n',
              isMultiOption: false,
              description: 'name of the template to remove.'),
          DartedArgument(
              name: 'output',
              abbreviation: 'o',
              isMultiOption: false,
              description: 'output directory for the archive file.'),
        ],
        flags: [
          DartedFlag.help,
        ],
        callback: (args, flags) async => await ExportTemplateCallback(
            args?['name'] ?? args?['n'], args?['output'] ?? args?['o']),
      ),
      //S2 -- Import
      DartedCommand(
        name: 'import',
        helperDescription:
            "Import a template from a previously exported zip archive.",
        arguments: [
          DartedArgument(
              name: 'file',
              abbreviation: 'f',
              isMultiOption: false,
              description: 'directory of the archive file.'),
        ],
        flags: [
          DartedFlag.help,
        ],
        callback: (args, flags) async =>
            await ImportTemplateCallback(args?['file'] ?? args?['f']),
      ),
    ],
  ),
  //S1 - Create
  DartedCommand(
    name: 'create',
    flags: [
      DartedFlag.help,
    ],
    helperDescription: "Create a new project based on a template.",
    arguments: [
      DartedArgument(
          name: 'template',
          abbreviation: 't',
          isMultiOption: false,
          description:
              'name of the template to create the Flutter project with.'),
      DartedArgument(
          name: 'name',
          abbreviation: 'n',
          isMultiOption: false,
          description: "your new Flutter project's name"),
    ],
    callback: (args, flags) async => await createCallBack(
      args?['template'] ?? args?['t'],
      args?['name'] ?? args?['n'],
    ),
  ),
];
