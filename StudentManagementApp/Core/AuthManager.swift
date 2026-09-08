//
//  AuthManager.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 04/09/26.
//

import UIKit
import CoreData

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    private let loggedInKey = "isLoggedIn"
    private let activeAdminKey = "activeAdminEmail"
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: loggedInKey)
    }

    /// Email of currently logged-in admin (lowercased) — persisted in UserDefaults
    var currentAdminEmail: String? {
        return UserDefaults.standard.string(forKey: activeAdminKey)
    }

    /// Fetch Admin object for the current session from Core Data
    var currentAdmin: Admin? {
        guard let email = currentAdminEmail else { return nil }
        return CoreDataManager.shared.fetchAdmin(byEmail: email)
    }
    
    func login(email: String) {
        UserDefaults.standard.set(true, forKey: loggedInKey)
        UserDefaults.standard.set(email.lowercased(), forKey: activeAdminKey)
        
        setRootViewController(storyboardID: "MainTabBarController")
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: loggedInKey)
        UserDefaults.standard.removeObject(forKey: activeAdminKey)
        
        // Logout ke baad bhi Welcome hi home hai – programmatically via WelcomeRouter / setRoot
        setRootViewController(storyboardID: "WelcomeViewController")
        // Alternative: WelcomeRouter.shared.setWelcomeAsRoot(window: currentWindow) – programmatic
    }

    private var currentWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate else { return nil }
        return delegate.window
    }
    
    func setRootViewController(storyboardID: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: storyboardID)
        
        let rootVC: UIViewController
        if storyboardID == "LoginViewController" || storyboardID == "WelcomeViewController" {
            let nav = UINavigationController(rootViewController: targetVC)
            nav.setNavigationBarHidden(storyboardID == "WelcomeViewController", animated: false)
            rootVC = nav
        } else {
            rootVC = targetVC
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = rootVC
        }, completion: { _ in
            ThemeManager.shared.applyCurrent()
        })
    }
}
