import "package:data/src/data_source/sdk/analytics/events/analytics_event.dart";

class ApiExceptionEvent extends AnalyticsEvent {
  ApiExceptionEvent({Map<String, dynamic> props = const {}})
      : super(name: "api_error", params: <String, dynamic>{...props});
}
