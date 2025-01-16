import 'dart:io';

import 'package:darted_cli/console_helper.dart';

import '../../helpers/prints_helper.dart';
import 'package:path/path.dart' as p;

Future<String?> getFlutterSdkPath() async {
  String? ret;

  // Try environment variable first
  String? flutterPath = Platform.environment['FLUTTER_ROOT'];
  if (flutterPath != null && Directory(flutterPath).existsSync()) {
    ret = flutterPath;
  }

  // Check common installation paths
  final List<String> possiblePaths = [
    // FVM default path
    '${Platform.environment['USERPROFILE']}\\fvm\\default\\bin',
    // Standard Flutter installation paths
    '${Platform.environment['LOCALAPPDATA']}\\flutter\\bin',
    '${Platform.environment['USERPROFILE']}\\flutter\\bin',
    // Add more paths as needed
  ];

  for (String path in possiblePaths) {
    final String flutterExe =
        Platform.isWindows ? '$path\\flutter.bat' : '$path/flutter';

    if (File(flutterExe).existsSync()) {
      // Go up one level from bin directory to get SDK root
      ret = Directory(path).parent.path;
    }
  }

  // If we still haven't found it, try running flutter --version
  try {
    final result = await Process.run(
      'flutter',
      ['--version'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      // If flutter command works, it means it's in PATH
      // Try to get its location through dart:io
      final executablePath = Platform.resolvedExecutable;
      final dartSdkPath = Directory(executablePath).parent.parent.path;
      final possibleFlutterPath = Directory(dartSdkPath).parent.path;

      if (Directory('$possibleFlutterPath/bin').existsSync()) {
        ret = possibleFlutterPath;
      }
    }
  } catch (e) {
    PrintsHelper.printError(
        "Failed to fetch Flutter's SDK path. Are you sure it's all set up?");
    ConsoleHelper.exit(1);
  }

  return ret != null
      ? p.join(ret, 'bin', Platform.isWindows ? 'flutter.bat' : 'flutter')
      : null;
}
