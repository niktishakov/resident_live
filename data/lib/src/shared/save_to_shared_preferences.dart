import "dart:convert";

import "package:data/src/data_source/sdk/workmanager/background_loggger.dart";
import "package:geolocator/geolocator.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<void> savePositionToPrefs(Position position) async {
  final logger = BackgroundLogger();
  final prefs = SharedPreferencesAsync();
  const key = "background_positions";

  final currentList = await prefs.getStringList(key) ?? [];

  final newEntry = jsonEncode({
    "latitude": position.latitude,
    "longitude": position.longitude,
    "timestamp": DateTime.now().toIso8601String(),
  });

  currentList.add(newEntry);

  await prefs.setStringList(key, currentList);
  await logger.debug("position updated in SharedPreferences: $newEntry");
}
