import 'dart:io';

import 'package:darted_cli/io_helper.dart';

Future<void> openFolder(String folderPath) async {
  // Ensure the folder exists
  if (!await Directory(folderPath).exists()) {
    throw DirectoryDoesntExist(path: folderPath);
  }

  // Determine the command based on the operating system
  String command;
  List<String> args;

  if (Platform.isWindows) {
    // Windows command
    command = 'explorer';
    args = [folderPath.replaceAll('/', '\\')]; // Convert to Windows-style paths
  } else if (Platform.isMacOS) {
    // macOS command
    command = 'open';
    args = [folderPath];
  } else if (Platform.isLinux) {
    // Linux command
    command = 'xdg-open';
    args = [folderPath];
  } else {
    throw Exception(
        "Unsupported operating system: ${Platform.operatingSystem}");
  }

  // Execute the command
  await Process.run(command, args);
}
