import "package:domain/domain.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:resident_live/screens/map/model/travel_route_model.dart";

class AppleGlobeView extends StatefulWidget {
  const AppleGlobeView({this.countryCodes = const [], this.stayPeriods, super.key});

  final List<String> countryCodes;
  final List<StayPeriodValueObject>? stayPeriods;

  @override
  State<AppleGlobeView> createState() => AppleGlobeViewState();
}

class AppleGlobeViewState extends State<AppleGlobeView> {
  MethodChannel? _channel;
  Function(String)? onCountrySelected;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final travelGraph = widget.stayPeriods != null
          ? TravelGraph.fromStayPeriods(widget.stayPeriods!)
          : const TravelGraph(routes: [], countries: {});

      return UiKitView(
        viewType: "AppleGlobeView",
        creationParams: {"countryCodes": widget.countryCodes, "travelGraph": travelGraph.toMap()},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      );
    }
    return const Text("Apple Globe is only available on iOS 15+");
  }

  void _onPlatformViewCreated(int id) {
    debugPrint("[TouchDebug] Platform view created with ID: $id");
    _channel = MethodChannel("com.resident.maps/globe_$id");
    _channel?.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    debugPrint("[TouchDebug] Method call received: ${call.method}");
    switch (call.method) {
      case "onCountrySelected":
        if (call.arguments is String && onCountrySelected != null) {
          debugPrint("[TouchDebug] Country selected: ${call.arguments}");
          onCountrySelected!(call.arguments as String);
        }
        break;
    }
  }

  Future<void> centerOnCountry(String countryCode) async {
    debugPrint("[TouchDebug] centerOnCountry called: $countryCode");
    if (_channel != null) {
      try {
        await _channel!.invokeMethod("centerOnCountry", countryCode);
      } catch (e) {
        debugPrint("[TouchDebug] Failed to center on country: $e");
      }
    }
  }

  Future<void> selectCountry(String countryCode) async {
    debugPrint("[TouchDebug] selectCountry called: $countryCode");
    if (_channel != null) {
      try {
        await _channel!.invokeMethod("selectCountry", countryCode);
      } catch (e) {
        debugPrint("[TouchDebug] Failed to select country: $e");
      }
    }
  }

  Future<void> refreshTouchHandling() async {
    debugPrint("[TouchDebug] refreshTouchHandling called - IGNORED");
  }

  Future<void> centerOnCurrentLocation() async {
    debugPrint("[TouchDebug] centerOnCurrentLocation called");
    if (_channel != null) {
      try {
        await _channel!.invokeMethod("centerOnCurrentLocation");
      } catch (e) {
        debugPrint("[TouchDebug] Failed to center on current location: $e");
      }
    }
  }

  void setOnCountrySelectedCallback(Function(String) callback) {
    onCountrySelected = callback;
  }
}
