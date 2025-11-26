import Foundation
// MainFlow.swift

import UIKit

struct MainFlow {
    
    // MARK: - Core Flow Entry Point
    
    // Helper to get the main storyboard instance
    private static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    // Method to launch the main map view (used in SceneDelegate/AppDelegate)
    static func presentMap(in window: UIWindow?) {
        let mapVC = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController")
        let navigationController = UINavigationController(rootViewController: mapVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Transitions
    
    // From MapVC to ARVC (Push/Present)
    static func navigateToAR(from viewController: UIViewController) {
        let arVC = mainStoryboard.instantiateViewController(withIdentifier: "ARViewController")
        viewController.navigationController?.pushViewController(arVC, animated: true)
        
        // OR: viewController.present(arVC, animated: true) if it's a modal transition
    }
    
    // From MapVC to CreateExperienceVC (Modal Presentation)
    static func presentCreateExperience(from viewController: UIViewController) {
        let createVC = mainStoryboard.instantiateViewController(withIdentifier: "CreateExperienceViewController")
        let navigationController = UINavigationController(rootViewController: createVC)
        
        // Use a modal presentation style (e.g., .pageSheet)
        viewController.present(navigationController, animated: true)
    }
    
    // Used by CreateExperienceVC to dismiss itself
    static func dismissModal(from viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
