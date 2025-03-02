// import 'package:darted_cli/ascii_art_module.dart';
// import 'package:darted_cli/console_helper.dart';
// import 'package:darted_cli/darted_cli.dart';

// /// The default helper for flutter_templify
// Future<String> defaultEntryHelper(List<DartedCommand> commandsTree) async {
//   String packageName = "flutter_templify";
//   String packageDescription =
//       "flutter_templify is a customizable CLI tool for managing Flutter app templates with YAML-based project definitions.";
//   //
//   bool hasSubCommands = commandsTree.isNotEmpty;
//   Map<String, String> subCommandsHelpersMap = Map.fromEntries(commandsTree
//       .map((s) => MapEntry(s.name, s.helperDescription ?? 'No Helper Message.'))
//       .toList());
//   String? justifiedCommands = hasSubCommands && subCommandsHelpersMap.isNotEmpty
//       ? ConsoleHelper.justifyMap(subCommandsHelpersMap,
//               gapSeparatorSize: 8, preKey: '| ')
//           .reduce((a, b) => "$a\n$b")
//       : null;
//   //
//   String packageArt = await AsciiArtModule.textToAscii(packageName,
//       beforeEachLine: "|  ", color: ConsoleColor.green);
//   String usage = "Usage: $packageName sub-command [arguments...] (flags...)";
//   return """
// $startPrint
// $packageArt
// | $packageDescription
// | 
// | $usage
// | 
// $justifiedCommands
// | 
// | 
// $endPrint\n
// """;
// }

// const String startPrint = """|-------""";
// const String endPrint = """|-------""";
