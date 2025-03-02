import 'dart:io';

class Constants {
  /// Path of the environment configuration file.
  static final String? envPath = Platform.environment['FLUTTER_TEMPLIFY_PATH'];

  /// Is the Path of the environment configuration file availabel?
  static final bool envPathConfigured = envPath != null;

  /// Path of the templates directory
  static final String? templatesPath = "$envPath/templates";
}
