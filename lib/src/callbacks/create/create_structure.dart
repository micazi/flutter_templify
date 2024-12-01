import 'package:darted_cli/io_helper.dart';

import '../../constants.dart';

Future<void> createStructure(
    dynamic node, Directory baseDir, String templateName) async {
  if (node is List) {
    for (final item in node) {
      if (item is String) {
        // Handle folder or file based on trailing '/'
        if (item.endsWith('/')) {
          final newFolder = Directory(
              '${baseDir.path}/${item.substring(0, item.length - 1)}');

          // Skip platform folders (android, ios, web)
          if (_isPlatformFolder(newFolder)) {
            continue; // Skip creation of platform folders
          }

          if (!newFolder.existsSync()) {
            newFolder.createSync(recursive: true);
          } else {
            // Optionally overwrite or clear the folder content before recreating it
            newFolder.createSync(
                recursive: true); // Clear and recreate the folder if needed
          }
        } else {
          final newFile = File('${baseDir.path}/$item');

          if (_isPlatformFolder(newFile.parent)) {
            continue; // Skip platform files
          }

          if (!newFile.existsSync()) {
            newFile.createSync(recursive: true);
          } else {
            newFile.createSync(recursive: true); // Overwrite the file
          }
        }
      } else if (item is Map) {
        for (final entry in item.entries) {
          final key = entry.key;
          final value = entry.value;

          if (key.endsWith('/')) {
            final newFolder = Directory(
                '${baseDir.path}/${key.substring(0, key.length - 1)}');

            // Skip platform folders (android, ios, web)
            if (_isPlatformFolder(newFolder)) {
              continue; // Skip creation of platform folders
            }

            if (!newFolder.existsSync()) {
              newFolder.createSync(recursive: true);
            } else {
              newFolder.createSync(recursive: true); // Overwrite the folder
            }
            await createStructure(value, newFolder, templateName);
          } else {
            final newFile = File('${baseDir.path}/$key');

            if (_isPlatformFolder(newFile.parent)) {
              continue; // Skip platform files
            }

            if (!newFile.existsSync()) {
              newFile.createSync(recursive: true);
            } else {
              newFile.createSync(recursive: true); // Overwrite the file
            }

            if (value is String) {
              // Copy content from the referenced file
              final referenceFilePath =
                  "${Constants.templatesPath}${Platform.pathSeparator}$templateName${Platform.pathSeparator}$value";

              if (await IOHelper.file.exists(referenceFilePath)) {
                await IOHelper.file.writeString(newFile.path,
                    await IOHelper.file.readAsString(referenceFilePath));
              } else {}
            }
          }
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
