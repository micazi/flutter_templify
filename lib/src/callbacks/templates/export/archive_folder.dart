import 'dart:io';
import 'dart:convert'; // For ZLibEncoder

Future<void> archiveFolder(String sourceDirPath, String zipFilePath) async {
  final sourceDir = Directory(sourceDirPath);
  final zipFile = File(zipFilePath);

  if (!sourceDir.existsSync()) {
    throw Exception('Source directory does not exist: $sourceDirPath');
  }

  // Create the zip file
  final zipSink = zipFile.openWrite();

  // Helper function to add files to the archive
  void addFileToArchive(File file, String relativePath) {
    final fileBytes = file.readAsBytesSync();
    final header = _createZipHeader(relativePath, fileBytes.length);
    zipSink.add(header);
    zipSink.add(fileBytes);
  }

  // Traverse the directory recursively
  await _traverseDirectory(sourceDir, sourceDir.path, addFileToArchive);

  // Close the zip file
  await zipSink.close();
}

Future<void> _traverseDirectory(Directory dir, String rootPath,
    Function(File, String) addFileCallback) async {
  final files = dir.listSync(recursive: false);

  for (final file in files) {
    if (file is File) {
      final relativePath = file.path.substring(rootPath.length + 1);
      addFileCallback(file, relativePath);
    } else if (file is Directory) {
      await _traverseDirectory(file, rootPath, addFileCallback);
    }
  }
}

List<int> _createZipHeader(String fileName, int fileSize) {
  // ignore: deprecated_export_use
  final header = BytesBuilder();

  // Local file header signature
  header.add([0x50, 0x4B, 0x03, 0x04]);

  // Version needed to extract (20 = 2.0)
  header.add([0x14, 0x00]);

  // General purpose bit flag (0 = no compression)
  header.add([0x00, 0x00]);

  // Compression method (0 = stored, 8 = deflated)
  header.add([0x00, 0x00]);

  // Last mod file time and date
  header.add([0x00, 0x00, 0x00, 0x00]);

  // CRC-32 (not calculated here)
  header.add([0x00, 0x00, 0x00, 0x00]);

  // Compressed size (same as uncompressed size for stored files)
  header.add(_intToBytes(fileSize, 4));

  // Uncompressed size
  header.add(_intToBytes(fileSize, 4));

  // File name length
  header.add(_intToBytes(fileName.length, 2));

  // Extra field length
  header.add([0x00, 0x00]);

  // File name
  header.add(utf8.encode(fileName));

  return header.takeBytes();
}

List<int> _intToBytes(int value, int length) {
  final bytes = List<int>.filled(length, 0);
  for (var i = 0; i < length; i++) {
    bytes[i] = value & 0xFF;
    value >>= 8;
  }
  return bytes;
}
