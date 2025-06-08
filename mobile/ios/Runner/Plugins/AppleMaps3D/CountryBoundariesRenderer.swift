import Foundation
import MapKit
import CoreLocation

class CountryBoundariesRenderer {
    private var mapView: MKMapView
    private var countryCodes: [String]
    private var countryOverlays: [MKOverlay] = []
    private var countryBoundaries: [String: Any]?
    private var countryColors: [String: UIColor] = [:]
    
    init(mapView: MKMapView, countryCodes: [String]) {
        self.mapView = mapView
        self.countryCodes = countryCodes
        generateCountryColors()
    }
    
    func loadAndHighlightCountries() {
        loadCountriesJSON()
    }
    
    func centerOnCountry(countryCode: String, completion: @escaping (Bool) -> Void) {
        // Try to find in GeoJSON first
        if let boundaries = countryBoundaries,
           let features = boundaries["features"] as? [[String: Any]] {
            
            let countryFeature = features.first { feature in
                if let properties = feature["properties"] as? [String: Any],
                   let iso = properties["ISO3166-1-Alpha-2"] as? String {
                    return iso == countryCode
                }
                return false
            }
            
            if let feature = countryFeature,
               let geometry = feature["geometry"] as? [String: Any] {
                
                if let coordinates = extractCentralCoordinate(from: geometry) {
                    let camera = MKMapCamera()
                    camera.centerCoordinate = coordinates
                    camera.altitude = 5000000
                    camera.pitch = 45
                    camera.heading = 0
                    
                    mapView.setCamera(camera, animated: true)
                    completion(true)
                    return
                }
            }
        }
        
        // If not found in GeoJSON, use geocoding
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US_POSIX")
        
        geocoder.geocodeAddressString(countryCode, in: nil, preferredLocale: locale) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first else {
                completion(false)
                return
            }
            
            if let location = placemark.location {
                let camera = MKMapCamera()
                camera.centerCoordinate = location.coordinate
                camera.altitude = 5000000
                camera.pitch = 45
                camera.heading = 0
                
                self.mapView.setCamera(camera, animated: true)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getCountryCoordinate(countryCode: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        // Try to find in GeoJSON first
        if let boundaries = countryBoundaries,
           let features = boundaries["features"] as? [[String: Any]] {
            
            let countryFeature = features.first { feature in
                if let properties = feature["properties"] as? [String: Any],
                   let iso = properties["ISO3166-1-Alpha-2"] as? String {
                    return iso == countryCode
                }
                return false
            }
            
            if let feature = countryFeature,
               let geometry = feature["geometry"] as? [String: Any] {
                
                if let coordinates = extractCentralCoordinate(from: geometry) {
                    completion(coordinates)
                    return
                }
            }
        }
        
        // If not found in GeoJSON, use geocoding
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US_POSIX")
        
        geocoder.geocodeAddressString(countryCode, in: nil, preferredLocale: locale) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }
    
    func createOverlayRenderer(for overlay: MKOverlay) -> MKOverlayRenderer? {
        guard let polygon = overlay as? MKPolygon else { return nil }
        
        let renderer = MKPolygonRenderer(polygon: polygon)
        let countryCode = polygon.title ?? ""
        let baseColor = countryColors[countryCode] ?? UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        
        renderer.fillColor = baseColor.withAlphaComponent(0.3)
        renderer.strokeColor = baseColor.withAlphaComponent(0.8)
        renderer.lineWidth = 1.0
        return renderer
    }
    
    // MARK: - Private Methods
    
    private func loadCountriesJSON() {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonDict = jsonResult as? [String: Any] {
                    self.countryBoundaries = jsonDict
                    highlightCountries()
                }
            } catch {
                print("Error loading countries.json: \(error)")
                // If loading failed, use geocoding
                for countryCode in countryCodes {
                    geocodeAndHighlight(countryCode: countryCode)
                }
            }
        } else {
            print("countries.json not found")
            // If file not found, use geocoding
            for countryCode in countryCodes {
                geocodeAndHighlight(countryCode: countryCode)
            }
        }
    }
    
    private func highlightCountries() {
        guard let boundaries = countryBoundaries else { return }
        
        for countryCode in countryCodes {
            if let features = boundaries["features"] as? [[String: Any]] {
                let countryFeature = features.first { feature in
                    if let properties = feature["properties"] as? [String: Any],
                       let iso = properties["ISO3166-1-Alpha-2"] as? String {
                        return iso == countryCode
                    }
                    return false
                }
                
                if let feature = countryFeature {
                    createPolygonFromGeoJSON(feature: feature, countryCode: countryCode)
                } else {
                    // If country not found in GeoJSON, use geocoding
                    geocodeAndHighlight(countryCode: countryCode)
                }
            }
        }
    }
    
    private func createPolygonFromGeoJSON(feature: [String: Any], countryCode: String) {
        guard let geometry = feature["geometry"] as? [String: Any],
              let type = geometry["type"] as? String else { return }
        
        if type == "Polygon" {
            if let coordinates = geometry["coordinates"] as? [[[Double]]] {
                for ring in coordinates {
                    addPolygon(coordinates: ring, countryCode: countryCode)
                }
            }
        } else if type == "MultiPolygon" {
            if let coordinates = geometry["coordinates"] as? [[[[Double]]]] {
                for polygon in coordinates {
                    for ring in polygon {
                        addPolygon(coordinates: ring, countryCode: countryCode)
                    }
                }
            }
        }
    }
    
    private func addPolygon(coordinates: [[Double]], countryCode: String) {
        var mapCoordinates: [CLLocationCoordinate2D] = []
        
        for coordinate in coordinates {
            if coordinate.count >= 2 {
                // GeoJSON format: [longitude, latitude]
                let lon = coordinate[0]
                let lat = coordinate[1]
                mapCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
        }
        
        if mapCoordinates.count > 2 {
            let polygon = MKPolygon(coordinates: &mapCoordinates, count: mapCoordinates.count)
            polygon.title = countryCode
            
            mapView.addOverlay(polygon)
            countryOverlays.append(polygon)
        }
    }
    
    private func geocodeAndHighlight(countryCode: String) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US_POSIX")
        
        geocoder.geocodeAddressString(countryCode, in: nil, preferredLocale: locale) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first else { return }
            
            if let country = placemark.country {
                print("Geocoded country: \(country) for code: \(countryCode)")
                
                // Use MKLocalSearch to get more data about the country
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = country
                
                if let location = placemark.location {
                    let region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
                    )
                    searchRequest.region = region
                }
                
                let search = MKLocalSearch(request: searchRequest)
                search.start { [weak self] response, error in
                    guard let self = self, let response = response, let item = response.mapItems.first else { return }
                    
                    // Create circular boundary around country center
                    if let region = item.placemark.region as? CLCircularRegion {
                        self.createCircularBoundary(center: region.center, radius: region.radius, countryCode: countryCode)
                    } else if let location = item.placemark.location {
                        // If no region, use fixed radius
                        self.createCircularBoundary(center: location.coordinate, radius: 500000, countryCode: countryCode)
                    }
                }
            }
        }
    }
    
    private func createCircularBoundary(center: CLLocationCoordinate2D, radius: CLLocationDistance, countryCode: String) {
        // Create circular boundary as fallback
        let numberOfPoints = 36
        var coordinates: [CLLocationCoordinate2D] = []
        
        for i in 0..<numberOfPoints {
            let angle = Double(i) * (2 * Double.pi / Double(numberOfPoints))
            let coord = calculateCoordinate(from: center, distance: radius, bearing: angle)
            coordinates.append(coord)
        }
        
        // Close the polygon
        coordinates.append(coordinates[0])
        
        let polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
        polygon.title = countryCode
        
        mapView.addOverlay(polygon)
        countryOverlays.append(polygon)
    }
    
    // Helper function to calculate coordinates considering Earth's curvature
    private func calculateCoordinate(from origin: CLLocationCoordinate2D, distance: Double, bearing: Double) -> CLLocationCoordinate2D {
        let earthRadius = 6371000.0 // Earth radius in meters
        
        let lat1 = origin.latitude * .pi / 180
        let lon1 = origin.longitude * .pi / 180
        
        let distRatio = distance / earthRadius
        let bearingRad = bearing
        
        let lat2 = asin(sin(lat1) * cos(distRatio) + cos(lat1) * sin(distRatio) * cos(bearingRad))
        let lon2 = lon1 + atan2(sin(bearingRad) * sin(distRatio) * cos(lat1), cos(distRatio) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
    
    private func extractCentralCoordinate(from geometry: [String: Any]) -> CLLocationCoordinate2D? {
        guard let type = geometry["type"] as? String else { return nil }
        
        if type == "Polygon", let coordinates = geometry["coordinates"] as? [[[Double]]] {
            // Calculate centroid for polygon
            return calculateCentroid(coordinates: coordinates.first ?? [])
        } else if type == "MultiPolygon", let coordinates = geometry["coordinates"] as? [[[[Double]]]] {
            // Take centroid of first polygon in multipolygon
            if let firstPolygon = coordinates.first, let firstRing = firstPolygon.first {
                return calculateCentroid(coordinates: firstRing)
            }
        }
        
        return nil
    }
    
    private func calculateCentroid(coordinates: [[Double]]) -> CLLocationCoordinate2D? {
        guard !coordinates.isEmpty else { return nil }
        
        var totalLat: Double = 0
        var totalLon: Double = 0
        var count: Double = 0
        
        for coord in coordinates {
            if coord.count >= 2 {
                totalLon += coord[0]
                totalLat += coord[1]
                count += 1
            }
        }
        
        if count > 0 {
            return CLLocationCoordinate2D(latitude: totalLat / count, longitude: totalLon / count)
        }
        
        return nil
    }
    
    private func generateCountryColors() {
        for countryCode in countryCodes {
            // Generate unique seed for each country
            var hasher = Hasher()
            hasher.combine(countryCode)
            let seed = hasher.finalize()
            
            // Use seed for deterministic but random color
            srand48(seed)
            let hue = Float(drand48())
            let saturation: Float = 0.7 + Float(drand48()) * 0.2 // 0.7-0.9
            let brightness: Float = 0.7 + Float(drand48()) * 0.2 // 0.7-0.9
            
            let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
            countryColors[countryCode] = color
        }
    }
}