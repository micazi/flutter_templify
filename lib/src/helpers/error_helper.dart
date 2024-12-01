import 'package:darted_cli/console_helper.dart';

class ErrorHelper {
  static void print(String message) {
    ConsoleHelper.writeSpace();
    ConsoleHelper.write("""
||========
||
|| ${'[!]'.withColor(ConsoleColor.red)} ${message.withColor(ConsoleColor.lightRed)}
||
||========
""");
    ConsoleHelper.writeSpace();
  }
}
