// MapViewController.swift (Conceptual structure)

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var addExperienceButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request location permission
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "AR View", style: .plain, target: self, action: #selector(showARView))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExperienceFromCenter))
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        tapRecognizer.minimumPressDuration = 0.0
        mapView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExperiences()
    }
    
    // ...
    
    @objc func addExperienceFromCenter() {
        let selectedLocation = mapView.centerCoordinate
        placeTemporaryPin(at: selectedLocation)
        presentCreateExperience(with: selectedLocation)
    }
    
    func loadExperiences() {
        if let data = UserDefaults.standard.data(forKey: "experiences"),
//           decode raw data into array of struct
           let experiences = try? JSONDecoder().decode([Experience].self, from: data) {
            
            mapView.removeAnnotations(mapView.annotations)
            for experience in experiences {
                let annotation = MKPointAnnotation()
                annotation.title = experience.title
                annotation.coordinate = experience.coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        let selectedLocation = mapView.centerCoordinate
        placeTemporaryPin(at: selectedLocation)
        presentCreateExperience(with: selectedLocation)    }

    func presentCreateExperience(with coordinate: CLLocationCoordinate2D) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let createVC = storyboard.instantiateViewController(withIdentifier: "CreateExperienceViewController") as? CreateExperienceViewController {
            
            // PASS THE DATA
            createVC.currentSelectedLocation = coordinate
            
            let navigationController = UINavigationController(rootViewController: createVC)
            
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func showARView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate the ARViewController using its Storyboard ID
        if let arVC = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController {
            
            // Use pushViewController to slide the AR screen into view (it stays inside the Navigation Bar)
            self.navigationController?.pushViewController(arVC, animated: true)
        }
    }
    
    @objc func handleMapTap(_ sender: UILongPressGestureRecognizer) {
        // We only want to process the tap once, when the gesture starts
        if sender.state != .began {
            return
        }
        print("Map was tapped! Coordinate calculation is next...") // <-- ADD THIS LINE
        
        // 1. Get the touch point on the screen (in points)
        let touchPoint = sender.location(in: mapView)
        
        // 2. Convert the screen point to a geographic coordinate
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // 3. Place a visible object (Annotation)
        placeTemporaryPin(at: coordinate)
        
        // 4. Navigate to the Create Experience screen, passing the tapped location
        presentCreateExperience(with: coordinate)
    }
    
    func placeTemporaryPin(at coordinate: CLLocationCoordinate2D) {
        let tempAnnotations = mapView.annotations.filter { $0.title == "New Experience Location" }
        mapView.removeAnnotations(tempAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.title = "New Experience Location"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
