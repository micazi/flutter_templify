import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import '../../constants.dart';
import '../../helpers/helpers.exports.dart';

Future<void> createStructure(dynamic node, Directory baseDir,
    String templateName, Map<String, String> replacementsMap) async {
  if (node is Map) {
    for (final entry in node.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key.endsWith('/')) {
        //=> Folder
        final Directory newDirectory =
            Directory('${baseDir.path}/${key.substring(0, key.length - 1)}');

        // Skip platform folders (android, ios, web)...
        if (_isPlatformFolder(newDirectory)) {
          continue;
        }

        // Create the folder if it doesn't exist...
        if (!await IOHelper.directory.exists(newDirectory.absolute.path)) {
          await IOHelper.directory.create(newDirectory.absolute.path);
        }

        // Reloop in the nested structure with the new folder...
        await createStructure(
            value, newDirectory, templateName, replacementsMap);
      } else {
        //=> File
        final File newFile = File('${baseDir.path}/$key');

        // Skip platform files...
        if (_isPlatformFolder(newFile.parent)) {
          continue;
        }

        // Create the file if it doesn't exist...
        if (!await IOHelper.file.exists(newFile.absolute.path)) {
          await IOHelper.file.create(newFile.absolute.path);
        }

        // Copy reference content...
        if (value is String) {
          final String referenceFilePath =
              "${Constants.templatesPath}${Platform.pathSeparator}$templateName${Platform.pathSeparator}$value";

          // Re-validate the reference file exists...
          if (!await IOHelper.file.exists(referenceFilePath)) {
            PrintsHelper.printError(
                "Reference file '$referenceFilePath' doesn't exist.");
            ConsoleHelper.exit(1);
          }

          // Read the reference file content...
          String fileContent =
              await IOHelper.file.readAsString(referenceFilePath);

          // Perform replacements if replacementsMap is provided...
          if (replacementsMap.isNotEmpty) {
            fileContent = _replacePlaceholders(fileContent, replacementsMap);
          }

          // Write the modified content to the new file...
          await IOHelper.file.writeString(newFile.path, fileContent);
        }
      }
    }
  }
}

// Helper function to determine if a folder is a platform-specific folder (android, ios, web)
bool _isPlatformFolder(Directory dir) {
  final platformFolders = [
    'android',
    'ios',
    'web',
    'linux',
    'windows',
    'macos'
  ];
  final folderName = dir.uri.pathSegments.last;

  return platformFolders.contains(folderName);
}

/// Helper function to replace placeholders in a string using the replacementsMap.
String _replacePlaceholders(
    String content, Map<String, String> replacementsMap) {
  for (final entry in replacementsMap.entries) {
    final placeholder = '{{${entry.key}}}';
    final replacement = entry.value;
    content = content.replaceAll(placeholder, replacement);
  }
  return content;
}
