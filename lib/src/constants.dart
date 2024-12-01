import 'dart:io';

class Constants {
  static final String? envPath = Platform.environment['FLUTTER_TEMPLATER_PATH'];
  static final String? templatesPath = "$envPath/templates";
}
