
import CoreLocation

struct Experience: Codable {
    let id: UUID
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    // In a real app, 'imageURL' would point to CloudKit/Drive
    var imageName: String?
    
    // Computed property for convenience with MapKit/CoreLocation
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
