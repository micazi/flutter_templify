// Future<void> configureCallback() async {
// ConsoleHelper.loadWithTask(task: '', process: () async => await Future.delayed(const Duration(seconds: 3)), loaderSuccessReplacement: '');
// ConsoleHelper.write(SpinnerLoader())

// if (!validateEnvPathConfigured()) {
//   ErrorHelper.print("You haven't set the 'FLUTTER_TEMPLIFY_PATH' yet, please do so!");
//   return;
// }

// if (newPath == null) {
//   ErrorHelper.print("You need to provide the new path using '--path | -p' arguments");
//   return;
// }

// if (!await IOHelper.directory.exists(newPath)) {
//   ErrorHelper.print("Directory doesn't exist. Make sure to create it first.");
//   return;
// }

// String configFilePath = "${Constants.envPath}/config.yaml";
// String newSavingPath = "$newPath/templates";

// // Check the saved directory
// if (!await IOHelper.directory.exists(newSavingPath)) {
//   await IOHelper.directory.create(newSavingPath);
// }

// // Check the config file
// if (!await IOHelper.file.exists(configFilePath)) {
//   await IOHelper.file.create(configFilePath);
// }

// // Write to the config file
// await IOHelper.file.writeString(configFilePath, "savingDirectory: $newPath");

// // Write that the process is done.
// ConsoleHelper.write("All Done. The new templates location is ${newPath.withColor(ConsoleColor.green)}", newLine: true);

// // Exit the console.
// ConsoleHelper.exit(0);
// }
