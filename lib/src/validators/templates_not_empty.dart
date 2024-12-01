import 'dart:io';

import 'package:darted_cli/console_helper.dart';

Future<void> validateTemplatesNotEmpty(List<Directory> templatesDirs) async {
  if (templatesDirs.isEmpty) {
    ConsoleHelper.write("No templates found. Make sure to add templates first!",
        newLine: true);
    ConsoleHelper.exit(0);
  }
}
