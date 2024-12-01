import 'package:darted_cli/io_helper.dart';

import '../../constants.dart';

Future<String?> validateReferencesInStructure(
    dynamic node, String templateName) async {
  if (node is List) {
    for (final item in node) {
      if (item is Map) {
        for (final entry in item.entries) {
          final key = entry.key;
          final value = entry.value;

          if (!key.endsWith('/') && value is String) {
            // Check if the reference file exists
            String referenceFilePath =
                "${Constants.templatesPath}${Platform.pathSeparator}$templateName${Platform.pathSeparator}$value";
            if (!await IOHelper.file.exists(referenceFilePath)) {
              return value;
            }
          } else if (key.endsWith('/')) {
            // Recursively validate nested structures
            validateReferencesInStructure(value, templateName);
          }
        }
      } else if (item is String) {
        // Do nothing for standalone files and folders
      }
    }
  }
  return null;
}
