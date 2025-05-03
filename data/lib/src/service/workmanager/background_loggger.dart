import "dart:io";
import "package:injectable/injectable.dart";
import "package:path_provider/path_provider.dart";

enum _LogLevel {
  trace("🔎"),
  debug("💬"),
  info("💡"),
  warn("⚠️"),
  error("⛔");

  final String emoji;
  const _LogLevel(this.emoji);
}

@Singleton()
class BackgroundLogger {
  void error(String message) => _writeToLog(message, _LogLevel.error);
  void warn(String message) => _writeToLog(message, _LogLevel.warn);
  void info(String message) => _writeToLog(message, _LogLevel.info);
  void debug(String message) => _writeToLog(message, _LogLevel.debug);
  void trace(String message) => _writeToLog(message, _LogLevel.trace);

  Future<void> _writeToLog(String message, _LogLevel level) async {
    final directory = await getApplicationDocumentsDirectory();
    final logFile = File("${directory.path}/resident-live-logs.txt");

    if (!await logFile.exists()) {
      await logFile.create();
    }

    logFile.writeAsStringSync(
      "\n[BG PROCESS] ${level.emoji} [${level.name.toUpperCase()}] $message",
      mode: FileMode.append,
    );
  }
}
