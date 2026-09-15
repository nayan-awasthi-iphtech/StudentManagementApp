import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        } else {
            showAlert(title: "Registration Failed", message: "An account with this email is already registered")
        }
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            if let nav = navigationController {
                for vc in nav.viewControllers {
                    if vc is LoginViewController {
                        nav.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
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
