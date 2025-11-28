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
    
    func processImageForUpload(image: UIImage, completion: @escaping (Data?) -> Void) {
        // 1. Try to compress the image into JPEG data.
        // Setting compressionQuality to 0.7 (70%) is usually a good balance of size vs quality.
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Error: Could not convert image to JPEG data.")
            completion(nil)
            return
        }
        completion(imageData)
    }
    
    @objc func saveTapped() {
        // 1. Validation and Location Check
        guard let location = currentSelectedLocation else {
            print("Error: Experience location not set.")
            return
        }
        
        guard let image = selectedImageView.image else {
            // You might want to show an alert to the user here
            print("Error: Please select an image.")
            return
        }

        // 2. Prepare Data for Upload
        processImageForUpload(image: image) { [weak self] imageData in
            guard let self = self, let data = imageData else {
                return
            }
            
            // 3. Create the Experience object (without the final image URL yet)
            let newExperience = Experience(
                id: UUID(),
                title: self.titleTextField.text ?? "New AR Marker",
                description: self.descriptionTextView.text ?? "No description.",
                latitude: location.latitude,
                longitude: location.longitude,
                imageName: nil // Placeholder: will be set after upload
            )

            // 4. Begin Cloud Save Process
            // NOTE: This call will be completed when the FirebaseManager is built.
            FirebaseManager.shared.uploadExperience(experience: newExperience, imageData: data) { success in
                if success {
                    print("Experience successfully saved to Firebase!")
                } else {
                    print("Error saving experience to Firebase.")
                }
                // 5. Dismiss the screen regardless of success/failure for now
                // (You might want to show an error alert if success == false)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
