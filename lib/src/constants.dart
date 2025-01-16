import 'dart:io';

class Constants {
  static final String? envPath = Platform.environment['FLUTTER_TEMPLIFY_PATH'];
  static final bool envPathConfigured = envPath != null;
  static final String? templatesPath = "$envPath/templates";
}
