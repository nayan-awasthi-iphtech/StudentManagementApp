//
//  WelcomeRouter.swift
//  StudentManagementApp
//
//  Programmatically handles Welcome (home) navigation for first-time & logged-out users.
//  Storyboard UI (WelcomeViewController) + programmatic navigation (Router) ka combo.
//  Get Started / Log In -> LoginViewController (naye user ke liye).
//

import UIKit

final class WelcomeRouter {

    static let shared = WelcomeRouter()
    private init() {}

    // MARK: - Public API (programmatically)

    /// First time OR logout ke baad Welcome home se Login pe le jaana
    func navigateToLogin(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")

        // Agar nav stack me hai to push (programmatically), nahi to present
        if let nav = viewController.navigationController {
            nav.setNavigationBarHidden(false, animated: false)
            nav.pushViewController(loginVC, animated: true)
        } else {
            loginVC.modalPresentationStyle = .fullScreen
            viewController.present(loginVC, animated: true)
        }
    }

    /// Optional: CreateAccount pe le jaana (agar future me chahiye)
    func navigateToCreateAccount(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        if let nav = viewController.navigationController {
            nav.setNavigationBarHidden(false, animated: false)
            nav.pushViewController(createVC, animated: true)
        } else {
            createVC.modalPresentationStyle = .fullScreen
            viewController.present(createVC, animated: true)
        }
    }

    // MARK: - Root handling (programmatically)

    /// App launch ya logout pe Welcome ko root banana – SceneDelegate / AuthManager se call
    func setWelcomeAsRoot(window: UIWindow?, animated: Bool = true) {
        guard let window = window else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        let nav = UINavigationController(rootViewController: welcomeVC)
        nav.setNavigationBarHidden(true, animated: false)

        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.rootViewController = nav
            } completion: { _ in
                ThemeManager.shared.applyCurrent()
            }
        } else {
            window.rootViewController = nav
            ThemeManager.shared.applyCurrent()
        }
    }

    /// Welcome se hi check karke Login pe redirect (agar kahi direct call karna ho)
    func handleGetStarted(from viewController: UIViewController) {
        // Requirement: naye user / first time / logout -> Get Started == Login
        navigateToLogin(from: viewController)
    }
}
