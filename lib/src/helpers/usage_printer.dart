import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/darted_cli.dart';

String commandsUsagePrinter(DartedCommand command) {
  String helpDescription =
      "${command.name.withColor(ConsoleColor.cyan)} :- ${command.helperDescription}";
  String usage =
      "Usage: flutter_templify ${command.name} [--argumentKey value] [--flag, --no-flag]";
  String availableArgsTitle = "Available Arguments:";
  String argsList = (command.arguments?.isNotEmpty ?? false)
      ? (command.arguments
                  ?.map((a) =>
                      "--${a?.name},-${a?.abbreviation} [default: ${a?.defaultValue ?? 'N/A'}]")
                  .toList() ??
              [])
          .reduce((a, b) => "$a\n$b")
      : 'N/A'.withColor(ConsoleColor.lightRed);
  String availableFlagsTitle = "Available Flags:";
  String flagList = (command.flags?.isNotEmpty ?? false)
      ? (command.flags?.map((a) => "--${a.name},-${a.abbreviation}").toList() ??
              [])
          .reduce((a, b) => "$a\n$b")
      : 'N/A'.withColor(ConsoleColor.lightRed);
  String availableCommandsTitle = "Available Sub-commands:";
  String justifiedCommands = (command.subCommands?.isNotEmpty ?? false)
      ? ConsoleHelper.justifyMap(Map.fromEntries(command.subCommands?.map((c) =>
                  MapEntry(
                      c.name,
                      c.helperDescription ??
                          'N/A'.withColor(ConsoleColor.lightRed))) ??
              []))
          .reduce((a, b) => "$a\n| $b")
      : 'N/A'.withColor(ConsoleColor.lightRed);
  return """
|======
|
| $helpDescription
| 
| $usage
|
| $availableArgsTitle
| $argsList
|
| $availableFlagsTitle
| $flagList
|
| $availableCommandsTitle
| $justifiedCommands
|
|======
""";
}
