import 'package:darted_cli/io_helper.dart';

import 'temporary_directory_change.dart';

Future<String> convertRelativeToAbsolute(
    String filePath, String isRelativeToThisAbsolutePath) async {
  String p = '';
  await temporaryDirectoryChange(isRelativeToThisAbsolutePath, () async {
    p = File(filePath).absolute.path;
  });
  return p;
}
