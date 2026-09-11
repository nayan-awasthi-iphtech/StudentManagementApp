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

    func navigateToLogin(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")

        if let nav = viewController.navigationController {
            nav.setNavigationBarHidden(false, animated: false)
            nav.pushViewController(loginVC, animated: true)
        } else {
            loginVC.modalPresentationStyle = .fullScreen
            viewController.present(loginVC, animated: true)
        }
    }

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

    func handleGetStarted(from viewController: UIViewController) {
        navigateToLogin(from: viewController)
    }
}
