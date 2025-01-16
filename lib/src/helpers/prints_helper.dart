import 'package:darted_cli/console_helper.dart';

class PrintsHelper {
  static void printError(String message) {
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

  static void printInfo(String message) {
    ConsoleHelper.writeSpace();
    ConsoleHelper.write("""
||========
||
|| ${(message + ' :/').withColor(ConsoleColor.blue)}
||
||========
""");
    ConsoleHelper.writeSpace();
  }
}
