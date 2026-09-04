//
//  AuthManager.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 04/09/26.
//

import UIKit

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private let loggedInKey = "isLoggedIn"
    private let activeAdminKey = "activeAdminEmail"

    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: loggedInKey)
    }

    func login(email: String) {
        UserDefaults.standard.set(true, forKey: loggedInKey)
        UserDefaults.standard.set(email.lowercased(), forKey: activeAdminKey)
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: loggedInKey)
        UserDefaults.standard.removeObject(forKey: activeAdminKey)
        
        setRootViewController(storyboardID: "LoginViewController")
    }

    func setRootViewController(storyboardID: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: storyboardID)

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = targetVC
        }, completion: { _ in
            // Preserve whole-app theme after root change (new window/root loses override)
            ThemeManager.shared.applyCurrent()
        })
    }
}
