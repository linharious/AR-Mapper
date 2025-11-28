import Foundation
import UIKit

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}
    
    func uploadExperience(experience: Experience, imageData: Data, completion: @escaping (Bool) -> Void) {
        print("TEMPORARY: Simulating Firebase upload...")
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(true)
        }
    }
}
