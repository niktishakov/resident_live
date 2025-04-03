import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:resident_live/shared/shared.dart';

class LogUtils {
  static Future<void> writeToLog(String message, [String mode = 'INFO']) async {
    final directory = await getApplicationDocumentsDirectory();
    final logFile = File('${directory.path}/resident-live-logs.txt');

    if (!await logFile.exists()) {
      await logFile.create();
    }

    final emoji = modeEmojis[mode] ?? '';
    logFile.writeAsStringSync('\n[BG PROCESS] $emoji [$mode] $message',
        mode: FileMode.append);
  }
}
