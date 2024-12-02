import 'dart:io';

class Constants {
  static final String? envPath = Platform.environment['FLUTTER_TEMPLIFY_PATH'];
  static final String? templatesPath = "$envPath/templates";
}
