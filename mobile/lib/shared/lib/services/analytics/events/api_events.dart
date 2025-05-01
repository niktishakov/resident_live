import "package:resident_live/shared/lib/services/analytics/events/analytics_event.dart";

class ApiExceptionEvent extends AnalyticsEvent {
  ApiExceptionEvent({
    Map<String, dynamic> props = const {},
  }) : super(
          name: "api_error",
          params: <String, dynamic>{
            ...props,
          },
        );
}
