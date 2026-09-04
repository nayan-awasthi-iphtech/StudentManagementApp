import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // cornerRadius via code ensures runtime matches storyboard preview
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for v in view.subviews where v.frame.height == 52 || v.frame.height == 50 {
            v.layer.cornerRadius = 12
            v.layer.masksToBounds = true
            v.clipsToBounds = true
        }
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
       guard let name = nameField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty,
             let email = emailField.text?.trimmingCharacters(in: .whitespaces),!email.isEmpty,
             let password = passwordField.text?.trimmingCharacters(in: .whitespaces), !password.isEmpty else {
           showAlert(title: "OK", message: "Please fill all the fields")
           return
       }
        
        let success = CoreDataManager.shared.registerAdmin(name: name, email: email, password: password)
        
        if success {
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
            showAlert(title: "Registration Failed", message: "An account with this email is already registered")
        }
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        // Handle both modal present and nav push cases (Login as root vs CreateAccount as initial)
        if presentingViewController != nil {
            dismiss(animated: true)
        } else if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            // CreateAccount was pushed from Login root nav -> pop, or if no nav fallback to setRoot to Login
            if let nav = navigationController {
                // If Login is root, pop to it
                for vc in nav.viewControllers {
                    if vc is LoginViewController {
                        nav.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
            // Fallback: set root to Login — preserve theme
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let nav = UINavigationController(rootViewController: loginVC)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = nav
                }, completion: { _ in ThemeManager.shared.applyCurrent() })
            }
        }
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
