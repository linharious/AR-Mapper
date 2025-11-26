//
//  CreateExperienceViewController.swift
//  AR-Mapper
//
//  Created by Tran Linh on 26/11/25.
//

import UIKit
import CoreLocation

class CreateExperienceViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var currentSelectedLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // CreateExperienceViewController.swift (Conceptual structure)
    
    // ... (Input outlets for title, description, and save button)
    
    func saveExperience() {
        // 1. Get current list of experiences
        var allExperiences: [Experience] = []
        if let data = UserDefaults.standard.data(forKey: "experiences"),
           let existing = try? JSONDecoder().decode([Experience].self, from: data) {
            allExperiences = existing
        }
        
        // 2. Create the new Experience (Use the user's current location for the lat/lon)
        guard let location = currentSelectedLocation else {
            print("Error: Location data is missing.")
            // You might want to show an alert to the user here.
            return
        }
        
        let newExperience = Experience(
            id: UUID(),
            title: titleTextField.text ?? "New AR Marker",
            description: descriptionTextView.text ?? "",
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        // 3. Append and save back to UserDefaults
        allExperiences.append(newExperience)
        if let encoded = try? JSONEncoder().encode(allExperiences) {
            UserDefaults.standard.set(encoded, forKey: "experiences")
        }
        
        // 4. Dismiss and go back to MapVC
        dismiss(animated: true, completion: nil)
    }
    
    
}
