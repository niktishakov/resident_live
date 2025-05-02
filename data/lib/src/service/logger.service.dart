import "dart:convert";
import "dart:io";

import "package:injectable/injectable.dart";
import "package:logging/logging.dart";
import "package:path_provider/path_provider.dart";

@singleton
class LoggerService {
  LoggerService(String className) : _logger = Logger(className);

  static final _levelEmoji = <Level, String>{
    Level.FINE: "🔎",
    Level.CONFIG: "💬",
    Level.INFO: "💡",
    Level.WARNING: "⚠️",
    Level.SEVERE: "⛔",
  };

  static final _levelName = <Level, String>{
    Level.FINE: "TRACE",
    Level.CONFIG: "DEBUG",
    Level.INFO: "INFO",
    Level.WARNING: "WARN",
    Level.SEVERE: "ERROR",
  };

  static const JsonEncoder jsonEncoder = JsonEncoder.withIndent("  ");

  late final File _logFile;
  final Logger _logger;

  @PostConstruct()
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File("${directory.path}/resident-live-logs.txt");
    if (!await _logFile.exists()) {
      await _logFile.create();
    } else {
      _logFile.writeAsStringSync("", mode: FileMode.append);
    }

    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((rec) async {
      final entry =
          "${rec.time.toIso8601String()} ${_levelEmoji[rec.level]} ${_levelName[rec.level]} - "
          "[${rec.loggerName}] ${_stringifyMessage(rec.message)}";

      // ignore: avoid_print
      print(entry);
      _logFile.writeAsStringSync("\n$entry", mode: FileMode.append);
    });
  }

  String _stringifyMessage(dynamic message) {
    return message is Map || message is Iterable ? jsonEncoder.convert(message) : message.toString();
  }

  void trace(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  void debug(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.config(message, error, stackTrace);
  }

  void info(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  void warning(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  File get logFile => _logFile;
}
