import 'package:darted_cli/darted_cli.dart';
import 'package:flutter_templify/flutter_templify.dart';

/// The main entry point for **flutter_template**
void main(List<String> input) => dartedEntry(
      input: input,
      commandsTree: commandsTree,
    );
