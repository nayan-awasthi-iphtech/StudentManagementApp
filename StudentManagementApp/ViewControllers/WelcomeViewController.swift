//
//  WelcomeViewController.swift
//  StudentManagementApp
//
//  Created on 08/09/26.
//

import UIKit

class WelcomeViewController: UIViewController {

    // All UI is built in Main.storyboard. No programmatic views.
    // Outlets are optional – kept for minor polish (corner radius) if needed.
    @IBOutlet weak var heroImageView: UIImageView?
    @IBOutlet weak var getStartedButton: UIButton?
    @IBOutlet weak var logInButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        ThemeManager.shared.applyCurrent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Storyboard handles most styling via runtime attributes.
        // Ensure hero image has rounded corners – can't do via IB alone for dynamic height.
        heroImageView?.layer.cornerRadius = 16
        heroImageView?.clipsToBounds = true
        heroImageView?.layer.masksToBounds = true

        getStartedButton?.layer.cornerRadius = 12
        getStartedButton?.layer.masksToBounds = true
    }

    // MARK: - Actions (programmatically handled via WelcomeRouter)
    // First time user OR after logout (not logged in) -> Welcome is home.
    // Get Started => Login (naye user ke liye seedha Login pe)
    @IBAction func getStartedTapped(_ sender: Any) {
        WelcomeRouter.shared.navigateToLogin(from: self)
    }

    @IBAction func logInTapped(_ sender: Any) {
        WelcomeRouter.shared.navigateToLogin(from: self)
    }
}
