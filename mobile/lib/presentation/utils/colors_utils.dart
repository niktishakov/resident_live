import 'package:flutter/material.dart';

Map<String, Color> getCountryColors(List<String> countries) {
  return {
    for (var country in countries)
      country: Colors
          .primaries[countries.indexOf(country) % Colors.primaries.length],
  };
}
