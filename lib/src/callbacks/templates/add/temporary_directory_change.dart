import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';

import '../../../helpers/prints_helper.dart';

Future<T> temporaryDirectoryChange<T>(
  String? theDoingDirectoryPath,
  Future<T> Function() whatToDo, {
  bool generateIfDoesntExist = false,
}) async {
  T res;
  String theMainWorkingDirectory = IOHelper.directory.getCurrent();
  if (theDoingDirectoryPath != null) {
    if (!await IOHelper.directory.exists(theDoingDirectoryPath)) {
      if (generateIfDoesntExist) {
        await IOHelper.directory.create(theDoingDirectoryPath);
      } else {
        PrintsHelper.printError(
            "The directory $theDoingDirectoryPath' doesn't exist.");
        ConsoleHelper.exit(1);
      }
    }
    await IOHelper.directory.change(theDoingDirectoryPath);
  }
  //
  res = await whatToDo();
  //
  await IOHelper.directory.change(theMainWorkingDirectory);
  return res;
}
