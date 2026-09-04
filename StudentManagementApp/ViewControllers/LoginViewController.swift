import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for v in view.subviews where v.frame.height == 52 || v.frame.height == 50 {
            v.layer.cornerRadius = 12
            v.layer.masksToBounds = true
            v.clipsToBounds = true
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Case 1: Login was presented modally from CreateAccount -> dismiss
        if presentingViewController != nil {
            dismiss(animated: true)
            return
        }
        // Case 2: Login is root in nav (SceneDelegate not logged in) -> push CreateAccount
        if let nav = navigationController {
            if nav.viewControllers.count > 1 {
                nav.popViewController(animated: true)
                return
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let createVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
                nav.pushViewController(createVC, animated: true)
                return
            }
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
        // If this never prints when popping/dismissing, you have a retain cycle
        print("LoginViewController deallocated - no leak")
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email and password.")
            return
        }
        
        if let admin = CoreDataManager.shared.fetchAdmin(byEmail: email), admin.password == password {
            AuthManager.shared.login(email: email)
            // Navigate to Students list wrapped in NavigationController — preserve theme
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let studentVC = storyboard.instantiateViewController(withIdentifier: "Students")
            let nav = UINavigationController(rootViewController: studentVC)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = nav
                }, completion: { _ in ThemeManager.shared.applyCurrent() })
            }
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
