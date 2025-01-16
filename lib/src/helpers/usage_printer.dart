import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/darted_cli.dart';

/// Print the usage (help) description .
String commandsUsagePrinter(DartedCommand command) {
  String helpDescription =
      "${command.name.withColor(ConsoleColor.cyan)} :- ${command.helperDescription}";
  String usage =
      "Usage: flutter_loc ${command.name} [--argumentKey value] [--flag, --no-flag]";
  String availableArgsTitle = "Available Arguments:";
  Map<String, String> argsList = Map.fromEntries(command.arguments
          ?.map((a) => MapEntry(
              "--${a?.name},-${a?.abbreviation} [default: ${a?.defaultValue ?? 'N/A'}]",
              a?.description?.withColor(ConsoleColor.grey) ?? ''))
          .toList() ??
      []);
  String justifiedArgs = (command.arguments?.isNotEmpty ?? false)
      ? ConsoleHelper.justifyMap(argsList, gapSeparatorSize: 4)
          .reduce((a, b) => "$a\n| $b")
      : 'N/A'.withColor(ConsoleColor.lightRed);
  String availableFlagsTitle = "Available Flags:";
  Map<String, String> flagList = Map.fromEntries(command.flags
          ?.map((f) => MapEntry(
              "--${f.name},-${f.abbreviation}${f.canBeNegated ? '  (Negatable)'.withColor(ConsoleColor.magenta) : ''}${f.appliedByDefault ? '  (Defaultly applied)' : ''}",
              f.description?.withColor(ConsoleColor.grey) ?? ''))
          .toList() ??
      []);
  String justifiedFlags = (command.flags?.isNotEmpty ?? false)
      ? ConsoleHelper.justifyMap(flagList, gapSeparatorSize: 4)
          .reduce((a, b) => "$a\n| $b")
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
| $justifiedArgs
|
| $availableFlagsTitle
| $justifiedFlags
|
| $availableCommandsTitle
| $justifiedCommands
|
|======
""";
}
