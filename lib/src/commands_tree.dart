import 'package:darted_cli/darted_cli.dart';
import 'callbacks/create/create.callback.dart';
import 'callbacks/templates/add_template.callback.dart';
import 'callbacks/templates/list_templates.callback.dart';
import 'callbacks/templates/open_template.callback.dart';
import 'callbacks/templates/remove_template.callback.dart';
import 'helpers/extensions.dart';

/// The commands tree for the templater.
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
          DartedArgument(name: 'file', abbreviation: 'f', isMultiOption: false),
        ],
        flags: [
          DartedFlag.help,
          DartedFlag(
              name: 'overwrite',
              abbreviation: 'ow',
              canBeNegated: false,
              appliedByDefault: false),
        ],
        callback: (args, flags) async => await addTemplateCallback(args, flags),
      ),
      //S2 -- Open
      DartedCommand(
        name: 'open',
        helperDescription: "Open the template's containing folder to modify.",
        arguments: [
          DartedArgument(name: 'name', abbreviation: 'n', isMultiOption: false),
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
          DartedArgument(name: 'name', abbreviation: 'n', isMultiOption: false),
        ],
        flags: [
          DartedFlag.help,
        ],
        callback: (args, flags) async =>
            await removeTemplateCallback(args?['name'] ?? args?['n']),
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
      DartedArgument(name: 'template', abbreviation: 't', isMultiOption: false),
      DartedArgument(
          name: 'name',
          abbreviation: 'n',
          isMultiOption: false,
          defaultValue: 'new_flutter_project'),
    ],
    callback: (args, flags) async => await createCallBack(
      args?['template'] ?? args?['t'],
      args?['name'] ?? args?['n'],
    ),
  ),
];
