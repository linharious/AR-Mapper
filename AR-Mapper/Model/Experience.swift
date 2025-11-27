import CoreLocation
struct Experience: Codable {
    let id: UUID
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    var imageName: String?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
