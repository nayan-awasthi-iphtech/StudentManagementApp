
//
//  LandingPage.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 09/09/26.
//

import UIKit

final class LandingPage: UIViewController {
    @IBAction func getStartedTapped(_ sender: Any) {
        if let nav = navigationController {
            if let welcome = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
                nav.pushViewController(welcome, animated: true)
                return
            }
        }
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let tab = main.instantiateInitialViewController() {
            view.window?.rootViewController = tab
        }
    }
}

