import 'dart:io';

import 'package:darted_cli/console_helper.dart';

import '../../../../helpers/prints_helper.dart';

Future<void> validateTemplatesNotEmpty(List<Directory> templatesDirs) async {
  if (templatesDirs.isEmpty) {
    PrintsHelper.printInfo(
        "No templates found. Make sure to add templates first!");
    ConsoleHelper.exit(0);
  }
}
