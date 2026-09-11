//
//  AdminProfileViewController.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 07/09/26.
//

import UIKit

class AdminProfileViewController: UIViewController {
    
    @IBOutlet weak var AdminImage: UIImageView!
    @IBOutlet weak var adminName: UILabel!
    @IBOutlet weak var adminEmail: UILabel!
    @IBOutlet weak var accountDetails: UILabel!
    @IBOutlet weak var totalStudentsCount: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!

    @IBOutlet weak var adminDetailNameValueLabel: UILabel?
    @IBOutlet weak var adminDetailEmailValueLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadCurrentAdmin()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCurrentAdmin()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        AdminImage.layer.cornerRadius = AdminImage.frame.width / 2
        AdminImage.clipsToBounds = true
        AdminImage.contentMode = .scaleAspectFill
        AdminImage.layer.masksToBounds = true
    }

    private func loadCurrentAdmin() {
        let name: String
        let email: String

        if let admin = AuthManager.shared.currentAdmin {
            name = admin.name ?? "Admin"
            email = admin.email ?? "—"
        } else if let activeEmail = AuthManager.shared.currentAdminEmail,
                  let admin = CoreDataManager.shared.fetchAdmin(byEmail: activeEmail) {
            name = admin.name ?? "Admin"
            email = admin.email ?? activeEmail
        } else {
            name = "Admin"
            email = AuthManager.shared.currentAdminEmail ?? "—"
        }

        adminName.text = name
        adminEmail.text = email

        if let detailName = adminDetailNameValueLabel {
            detailName.text = name
        } else {
            findDetailLabel(placeholder: "John Doe")?.text = name
        }
        if let detailEmail = adminDetailEmailValueLabel {
            detailEmail.text = email
        } else {
            findDetailLabel(placeholder: "admin@example.com")?.text = email
        }

        let count = CoreDataManager.shared.fetchAllStudents().count
        totalStudentsCount.text = "\(count)"
    }

    private func findDetailLabel(placeholder: String) -> UILabel? {
        var queue: [UIView] = [view]
        while let v = queue.first {
            queue.removeFirst()
            if let label = v as? UILabel, label.text == placeholder {
                return label
            }
            queue.append(contentsOf: v.subviews)
        }
        return nil
    }

    private func configureUI() {
        AdminImage.tintColor = .black
        navigationItem.title = "Admin"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    @IBAction func LogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
