import "package:domain/domain.dart";

class TravelRoute {
  const TravelRoute({
    required this.fromCountryCode,
    required this.toCountryCode,
    required this.travelDate,
    required this.duration,
    required this.isFuture,
  });
  final String fromCountryCode;
  final String toCountryCode;
  final DateTime travelDate;
  final int duration;
  final bool isFuture;

  Map<String, dynamic> toMap() {
    return {
      "fromCountryCode": fromCountryCode,
      "toCountryCode": toCountryCode,
      "travelDate": travelDate.millisecondsSinceEpoch,
      "duration": duration,
      "isFuture": isFuture,
    };
  }
}

class TravelGraph {
  const TravelGraph({required this.routes, required this.countries});
  final List<TravelRoute> routes;
  final Set<String> countries;

  static TravelGraph fromStayPeriods(List<StayPeriodValueObject> stayPeriods) {
    if (stayPeriods.length < 2) {
      return const TravelGraph(routes: [], countries: {});
    }

    final routes = <TravelRoute>[];
    final countries = <String>{};
    final now = DateTime.now();

    // Сортируем периоды по дате начала
    final sortedPeriods = [...stayPeriods]..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (var i = 0; i < sortedPeriods.length - 1; i++) {
      final current = sortedPeriods[i];
      final next = sortedPeriods[i + 1];

      countries.add(current.countryCode);
      countries.add(next.countryCode);

      // Создаем маршрут от текущей страны к следующей
      if (current.countryCode != next.countryCode) {
        routes.add(
          TravelRoute(
            fromCountryCode: current.countryCode,
            toCountryCode: next.countryCode,
            travelDate: next.startDate,
            duration: next.days,
            isFuture: next.startDate.isAfter(now),
          ),
        );
      }
    }

    return TravelGraph(routes: routes, countries: countries);
  }

  Map<String, dynamic> toMap() {
    return {"routes": routes.map((r) => r.toMap()).toList(), "countries": countries.toList()};
  }
}
