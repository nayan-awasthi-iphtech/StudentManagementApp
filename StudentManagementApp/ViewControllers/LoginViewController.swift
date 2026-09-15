import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if presentingViewController != nil {
            dismiss(animated: true)
            return
        }
        if let nav = navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let createVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
            if let existing = nav.viewControllers.first(where: { $0 is CreateAccountViewController }) {
                nav.popToViewController(existing, animated: true)
                return
            }
            nav.pushViewController(createVC, animated: true)
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = createVC
            })
        }
    }
    
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
