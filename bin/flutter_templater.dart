import 'package:darted_cli/darted_cli.dart';
import 'package:flutter_templater/flutter_templater.dart';

/// The main entry point for **flutter_template**
void main(List<String> input) => dartedEntry(
      input: input,
      commandsTree: commandsTree,
      customHelpResponse: (c) => commandsUsagePrinter(c),
    );
