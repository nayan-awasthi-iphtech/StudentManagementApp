//
//  SceneDelegate.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 25/08/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if AuthManager.shared.isLoggedIn {
            // Instantiate the Tab Bar Controller directly instead of wrapping "Students" in a Nav Controller
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            window.rootViewController = tabBarVC
        } else {
            // First time OR logout (not logged in) -> Welcome is home (Storyboard UI, programmatic routing)
            // WelcomeRouter handles root programmatically
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
            let nav = UINavigationController(rootViewController: welcomeVC)
            nav.setNavigationBarHidden(true, animated: false)
            window.rootViewController = nav
            // Alternative programmatic way (same result): WelcomeRouter.shared.setWelcomeAsRoot(window: window, animated: false)
        }
        
        self.window = window
        window.makeKeyAndVisible()
        // Whole-app theme: restore saved theme to this new window and all windows
        ThemeManager.shared.applyCurrent()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
