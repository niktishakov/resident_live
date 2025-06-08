import Flutter
import UIKit
import MapKit
import CoreLocation

public class AppleMaps3DPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = AppleGlobeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "AppleGlobeView")
    }
}

class AppleGlobeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let params = args as? [String: Any]
        let countryCodes = params?["countryCodes"] as? [String] ?? []
        let travelGraph = params?["travelGraph"] as? [String: Any]
        return AppleGlobeView(frame: frame, viewId: viewId, messenger: messenger, countryCodes: countryCodes, travelGraph: travelGraph)
    }
}

class AppleGlobeView: NSObject, FlutterPlatformView, MKMapViewDelegate, TravelGraphRendererDelegate, CLLocationManagerDelegate {
    private var mapView: MKMapView
    private var channel: FlutterMethodChannel
    private var countryCodes: [String]
    private var locationManager: CLLocationManager
    
    // Feature renderers
    private var countryBoundariesRenderer: CountryBoundariesRenderer!
    private var travelGraphRenderer: TravelGraphRenderer!
    
    // Touch handling debug
    private var touchRefreshCount = 0
    
    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, countryCodes: [String], travelGraph: [String: Any]?) {
        self.mapView = MKMapView(frame: frame)
        self.countryCodes = countryCodes
        self.channel = FlutterMethodChannel(name: "com.resident.maps/globe_\(viewId)", binaryMessenger: messenger)
        self.locationManager = CLLocationManager()
        
        super.init()
        
        print("[TouchDebug] AppleGlobeView initialized")
        
        // Initialize feature renderers
        countryBoundariesRenderer = CountryBoundariesRenderer(mapView: mapView, countryCodes: countryCodes)
        travelGraphRenderer = TravelGraphRenderer(mapView: mapView, travelGraph: travelGraph)
        travelGraphRenderer.delegate = self
        
        configureLocation()
        configureMap()
        setupFeatures()
        
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            
            print("[TouchDebug] Native method call: \(call.method)")
            
            if call.method == "centerOnCountry" {
                if let countryCode = call.arguments as? String {
                    self.countryBoundariesRenderer.centerOnCountry(countryCode: countryCode) { success in
                        result(success)
                    }
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Expected country code", details: nil))
                }
            } else if call.method == "selectCountry" {
                if let countryCode = call.arguments as? String {
                    self.travelGraphRenderer.selectCountry(countryCode: countryCode)
                    result(true)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Expected country code", details: nil))
                }
            } else if call.method == "centerOnCurrentLocation" {
                self.centerOnCurrentLocation()
                result(true)
            } else if call.method == "refreshTouchHandling" {
                print("[TouchDebug] Touch refresh ignored")
                result(true)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func view() -> UIView {
        return mapView
    }

    private func configureLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    private func configureMap() {
        if #available(iOS 15.0, *) {
            let config = MKStandardMapConfiguration()
            mapView.preferredConfiguration = config
        }

        mapView.mapType = .hybridFlyover
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        print("[TouchDebug] Map configured, interaction enabled: \(mapView.isUserInteractionEnabled)")

        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        camera.altitude = 50000000
        camera.pitch = 0
        mapView.setCamera(camera, animated: false)
    }
    
    private func centerOnCurrentLocation() {
        guard let location = locationManager.location else {
            print("[Location] Current location not available")
            return
        }
        
        let camera = MKMapCamera()
        camera.centerCoordinate = location.coordinate
        camera.altitude = 1000000 // 1000km altitude for good overview
        camera.pitch = 45
        
        mapView.setCamera(camera, animated: true)
        print("[Location] Centered on current location: \(location.coordinate)")
    }
    
    private func setupFeatures() {
        countryBoundariesRenderer.loadAndHighlightCountries()
        travelGraphRenderer.setupTravelRoutes()
    }
    
    // MARK: - TravelGraphRendererDelegate
    
    func getCountryBoundariesRenderer() -> CountryBoundariesRenderer {
        return countryBoundariesRenderer
    }
    
    func didSelectCountry(countryCode: String) {
        print("[TouchDebug] Country selected in native: \(countryCode)")
        channel.invokeMethod("onCountrySelected", arguments: countryCode)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Try travel graph renderer first
        if let renderer = travelGraphRenderer.createOverlayRenderer(for: overlay) {
            return renderer
        }
        
        // Then try country boundaries renderer
        if let renderer = countryBoundariesRenderer.createOverlayRenderer(for: overlay) {
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Handle user location separately - use default blue dot
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "RouteAnnotation"
        return travelGraphRenderer.createAnnotationView(for: annotation, identifier: identifier)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("[TouchDebug] Annotation tapped in MapKit")
        guard let annotation = view.annotation else { return }
        
        let countryCode = travelGraphRenderer.handleAnnotationSelection(annotation, view: view)
        didSelectCountry(countryCode: countryCode)
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Location updates handled automatically by MapKit
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[Location] Failed to get location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("[Location] Location access denied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}