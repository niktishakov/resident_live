extension MapExtension on Map {
  Map<String, dynamic> filterNullValues() {
    return map((key, value) => MapEntry(key, value))
      ..removeWhere((key, value) => value == null);
  }
}
