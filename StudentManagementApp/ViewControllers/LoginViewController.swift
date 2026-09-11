import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Drizzle theme: strictly Storyboard-driven (no code cornerRadius)
        // Cards 14pt + button 28 capsule are set via IB runtime attributes
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Case 1: Login was presented modally from CreateAccount -> dismiss
        if presentingViewController != nil {
            dismiss(animated: true)
            return
        }
        // Welcome → Login → Sign Up must push CreateAccount (was incorrectly popping to Welcome when count>1)
        if let nav = navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let createVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
            // If CreateAccount already in stack, pop to it instead of pushing duplicate
            if let existing = nav.viewControllers.first(where: { $0 is CreateAccountViewController }) {
                nav.popToViewController(existing, animated: true)
                return
            }
            nav.pushViewController(createVC, animated: true)
            return
        }
        // Fallback: no nav, set root to CreateAccount
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = createVC
            })
        }
    }
    
    // Backward-compat alias — prevents crash if storyboard still references old selector
    @IBAction func signUpButtonType(_ sender: Any) {
        signUpButtonTapped(sender)
    }
    
    deinit {
        print("LoginViewController deallocated - no leak")
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email and password.")
            return
        }
        
        if let admin = CoreDataManager.shared.fetchAdmin(byEmail: email), admin.password == password {
            // AuthManager updates user defaults AND transitions rootViewController to MainTabBarController
            AuthManager.shared.login(email: email)
        } else {
            showAlert(title: "Login Failed", message: "Invalid email or password.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
