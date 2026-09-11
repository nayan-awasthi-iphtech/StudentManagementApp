import UIKit

class WelcomeViewController: UIViewController {

    @IBAction func getStartedTapped(_ sender: Any) {
        WelcomeRouter.shared.navigateToLogin(from: self)
    }

    @IBAction func logInTapped(_ sender: Any) {
        WelcomeRouter.shared.navigateToLogin(from: self)
    }
}
