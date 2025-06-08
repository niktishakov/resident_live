import Foundation
import MapKit
import CoreLocation
import Flutter

protocol TravelGraphRendererDelegate: AnyObject {
    func getCountryBoundariesRenderer() -> CountryBoundariesRenderer
    func didSelectCountry(countryCode: String)
}

class TravelGraphRenderer: NSObject {
    private var mapView: MKMapView
    private var travelRoutes: [[String: Any]] = []
    private var routePolylines: [MKPolyline] = []
    private var routeAnnotations: [MKAnnotation] = []
    private var selectedAnnotation: MKAnnotation?
    private var countryAnnotations: [String: MKAnnotation] = [:]
    
    weak var delegate: TravelGraphRendererDelegate?
    
    init(mapView: MKMapView, travelGraph: [String: Any]?) {
        self.mapView = mapView
        
        // Extract route data
        if let travelGraph = travelGraph,
           let routes = travelGraph["routes"] as? [[String: Any]] {
            self.travelRoutes = routes
        }
        
        super.init()
    }
    
    func setupTravelRoutes() {
        for route in travelRoutes {
            guard let fromCountry = route["fromCountryCode"] as? String,
                  let toCountry = route["toCountryCode"] as? String else { continue }
            
            addRoutePolyline(from: fromCountry, to: toCountry)
            addRouteAnnotations(from: fromCountry, to: toCountry)
        }
    }
    
    func selectCountry(countryCode: String) {
        // Reset previous selected annotation
        if let previousSelected = selectedAnnotation {
            if let previousView = mapView.view(for: previousSelected) as? MKMarkerAnnotationView {
                UIView.animate(withDuration: 0.2) {
                    previousView.transform = CGAffineTransform.identity
                }
            }
        }
        
        // Find annotation for selected country
        if let annotation = countryAnnotations[countryCode] {
            selectedAnnotation = annotation
            
            if let markerView = mapView.view(for: annotation) as? MKMarkerAnnotationView {
                UIView.animate(withDuration: 0.2) {
                    markerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }
            }
            
            // Center map on selected annotation
            let camera = MKMapCamera()
            camera.centerCoordinate = annotation.coordinate
            camera.altitude = 5000000
            camera.pitch = 45
            camera.heading = 0
            
            mapView.setCamera(camera, animated: true)
        }
    }
    
    func createOverlayRenderer(for overlay: MKOverlay) -> MKOverlayRenderer? {
        guard let polyline = overlay as? MKPolyline else { return nil }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.8)
        renderer.lineWidth = 1.5
        renderer.lineCap = .round
        renderer.lineJoin = .round
        return renderer
    }
    
    func createAnnotationView(for annotation: MKAnnotation, identifier: String) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let markerView = annotationView as? MKMarkerAnnotationView {
            // All annotations are now blue
            markerView.markerTintColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
            markerView.glyphTintColor = UIColor.white
            
            // Set size based on selection
            let isSelected = selectedAnnotation != nil &&
                             selectedAnnotation!.coordinate.latitude == annotation.coordinate.latitude &&
                             selectedAnnotation!.coordinate.longitude == annotation.coordinate.longitude
            
            let scale: CGFloat = isSelected ? 1.3 : 1.0
            markerView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return annotationView
    }
    
    func handleAnnotationSelection(_ annotation: MKAnnotation, view: MKAnnotationView) -> String {
        // Reset previous selected annotation
        if let previousSelected = selectedAnnotation {
            if let previousView = mapView.view(for: previousSelected) as? MKMarkerAnnotationView {
                UIView.animate(withDuration: 0.2) {
                    previousView.transform = CGAffineTransform.identity
                }
            }
        }
        
        // Set new selected annotation
        selectedAnnotation = annotation
        
        if let markerView = view as? MKMarkerAnnotationView {
            UIView.animate(withDuration: 0.2) {
                markerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
        }
        
        // Center map on selected annotation
        let camera = MKMapCamera()
        camera.centerCoordinate = annotation.coordinate
        camera.altitude = 5000000
        camera.pitch = 45
        camera.heading = 0
        
        mapView.setCamera(camera, animated: true)
        
        return findCountryCodeForAnnotation(annotation)
    }
    
    // MARK: - Private Methods
    
    private func addRoutePolyline(from fromCountry: String, to toCountry: String) {
        delegate?.getCountryBoundariesRenderer().getCountryCoordinate(countryCode: fromCountry) { [weak self] fromCoord in
            guard let self = self, let fromCoord = fromCoord else { return }
            
            self.delegate?.getCountryBoundariesRenderer().getCountryCoordinate(countryCode: toCountry) { [weak self] toCoord in
                guard let self = self, let toCoord = toCoord else { return }
                
                // Create curved line for beautiful display on globe
                let coordinates = self.createCurvedPath(from: fromCoord, to: toCoord)
                var coordinatesArray = coordinates
                let polyline = MKPolyline(coordinates: &coordinatesArray, count: coordinatesArray.count)
                
                DispatchQueue.main.async {
                    self.mapView.addOverlay(polyline)
                    self.routePolylines.append(polyline)
                }
            }
        }
    }
    
    private func addRouteAnnotations(from fromCountry: String, to toCountry: String) {
        delegate?.getCountryBoundariesRenderer().getCountryCoordinate(countryCode: fromCountry) { [weak self] fromCoord in
            guard let self = self, let fromCoord = fromCoord else { return }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = fromCoord
            annotation.title = fromCountry
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.routeAnnotations.append(annotation)
                self.countryAnnotations[fromCountry] = annotation
            }
        }
        
        delegate?.getCountryBoundariesRenderer().getCountryCoordinate(countryCode: toCountry) { [weak self] toCoord in
            guard let self = self, let toCoord = toCoord else { return }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = toCoord
            annotation.title = toCountry
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.routeAnnotations.append(annotation)
                self.countryAnnotations[toCountry] = annotation
            }
        }
    }
    
    // Create curved path between two points
    private func createCurvedPath(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        let numberOfPoints = 50
        var coordinates: [CLLocationCoordinate2D] = []
        
        // Calculate intermediate points considering Earth's curvature
        for i in 0...numberOfPoints {
            let fraction = Double(i) / Double(numberOfPoints)
            
            // Use spherical interpolation to create curved path
            let lat1 = from.latitude * .pi / 180
            let lon1 = from.longitude * .pi / 180
            let lat2 = to.latitude * .pi / 180
            let lon2 = to.longitude * .pi / 180
            
            let d = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1))
            
            let a = sin((1 - fraction) * d) / sin(d)
            let b = sin(fraction * d) / sin(d)
            
            let x = a * cos(lat1) * cos(lon1) + b * cos(lat2) * cos(lon2)
            let y = a * cos(lat1) * sin(lon1) + b * cos(lat2) * sin(lon2)
            let z = a * sin(lat1) + b * sin(lat2)
            
            let lat = atan2(z, sqrt(x * x + y * y)) * 180 / .pi
            let lon = atan2(y, x) * 180 / .pi
            
            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        return coordinates
    }
    
    private func findCountryCodeForAnnotation(_ annotation: MKAnnotation) -> String {
        for (countryCode, countryAnnotation) in countryAnnotations {
            if countryAnnotation.coordinate.latitude == annotation.coordinate.latitude &&
               countryAnnotation.coordinate.longitude == annotation.coordinate.longitude {
                return countryCode
            }
        }
        return ""
    }
}