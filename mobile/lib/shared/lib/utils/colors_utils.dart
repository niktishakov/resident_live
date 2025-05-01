import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

Map<String, Color> getCountryColors(List<String> countries) {
  final brightness = PlatformDispatcher.instance.platformBrightness;
  return {
    for (final country in countries)
      country: brightness == Brightness.dark
          ? Colors
              .primaries[countries.indexOf(country) % Colors.primaries.length]
              .shade500
          : Colors
              .primaries[countries.indexOf(country) % Colors.primaries.length]
              .shade600,
  };
}
