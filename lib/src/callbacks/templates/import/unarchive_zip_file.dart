import 'dart:io';
import 'dart:convert'; // For ZLibDecoder

Future<void> unarchiveZipFile(String zipFilePath, String targetDirPath) async {
  final zipFile = File(zipFilePath);
  final targetDir = Directory(targetDirPath);

  if (!zipFile.existsSync()) {
    throw Exception('Zip file does not exist: $zipFilePath');
  }

  // Create the target directory if it doesn't exist
  if (!targetDir.existsSync()) {
    targetDir.createSync(recursive: true);
  }

  // Read the zip file as bytes
  final zipBytes = await zipFile.readAsBytes();

  // Extract the zip file
  await _extractZip(zipBytes, targetDir);
}

Future<void> _extractZip(List<int> zipBytes, Directory targetDir) async {
  int offset = 0;

  while (offset + 30 < zipBytes.length) {
    // Read the local file header signature
    final signature = _bytesToInt(zipBytes.sublist(offset, offset + 4));
    if (signature != 0x04034b50) {
      break; // End of central directory reached
    }

    // Read file metadata
    final compressedSize =
        _bytesToInt(zipBytes.sublist(offset + 18, offset + 22));
    // final uncompressedSize = _bytesToInt(zipBytes.sublist(offset + 22, offset + 26));
    final fileNameLength =
        _bytesToInt(zipBytes.sublist(offset + 26, offset + 28));
    final extraFieldLength =
        _bytesToInt(zipBytes.sublist(offset + 28, offset + 30));

    // Read the file name
    final fileNameBytes =
        zipBytes.sublist(offset + 30, offset + 30 + fileNameLength);
    final fileName = utf8.decode(fileNameBytes);

    // Calculate the offset to the file data
    final fileDataOffset = offset + 30 + fileNameLength + extraFieldLength;

    // Read the file data
    final fileData =
        zipBytes.sublist(fileDataOffset, fileDataOffset + compressedSize);

    // Create the file or directory
    final filePath = '${targetDir.path}/$fileName';
    if (fileName.endsWith('/')) {
      // It's a directory
      await Directory(filePath).create(recursive: true);
    } else {
      // It's a file
      final file = File(filePath);
      await file.create(recursive: true);
      await file.writeAsBytes(fileData);
    }

    // Move to the next file in the zip
    offset = fileDataOffset + compressedSize;
  }
}

/// Helper function to convert a byte array to an integer
int _bytesToInt(List<int> bytes) {
  int value = 0;
  for (var i = 0; i < bytes.length; i++) {
    value += bytes[i] << (8 * i);
  }
  return value;
}
