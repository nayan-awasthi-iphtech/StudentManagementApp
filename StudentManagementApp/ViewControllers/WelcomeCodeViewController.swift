//
//  WelcomeCodeViewController.swift
//  StudentManagementApp
//
//  Ek aur file – pure programmatically (no Storyboard) Welcome UI.
//  Same 2004.i603...jpg (WelcomeHero) image ko code se layout kiya hai.
//  Jha code use karna ho wha programmatically – is file ka use alternative ke liye kar sakte ho.
//  Storyboard wala WelcomeViewController hi main home hai, ye file demo / reusable programmatic version hai.
//

import UIKit

final class WelcomeCodeViewController: UIViewController {

    // MARK: - Programmatic UI (no IBOutlets)

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        // 2004 file ko WelcomeHero asset ke through load (programmatically)
        iv.image = UIImage(named: "WelcomeHero") ?? UIImage(named: "2004.i603.001_online_education_set-11")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()

    private let welcomeSmallLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Welcome to"
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = .secondaryLabel
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Student Manager"
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: 28)
        l.textColor = UIColor.systemIndigo
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Manage students, courses and galleries — all in one beautiful, offline-first app."
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.numberOfLines = 2
        return l
    }()

    private let featuresCard: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    private let getStartedButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Get Started", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemBlue
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.layer.cornerRadius = 12
        b.layer.masksToBounds = true
        return b
    }()

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Already have an account? Log In", for: .normal)
        b.setTitleColor(UIColor.systemBlue, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15)
        return b
    }()

    private let footerLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Offline-first • Core Data • MVVM"
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        return l
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupHierarchy()
        setupConstraints()
        setupActions()
        setupFeaturesStack()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        ThemeManager.shared.applyCurrent()
    }

    // MARK: - Setup (programmatically)

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [heroImageView, welcomeSmallLabel, titleLabel, subtitleLabel, featuresCard, getStartedButton, loginButton, footerLabel].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupFeaturesStack() {
        // 3 rows programmatically inside featuresCard
        let row1 = makeFeatureRow(icon: "person.3.fill", text: "Add, edit & organize student profiles with photos")
        let row2 = makeFeatureRow(icon: "graduationcap.fill", text: "Create course galleries with photo collections")
        let row3 = makeFeatureRow(icon: "shield.lefthalf.filled.badge.checkmark", text: "Secure on-device storage with light & dark theme")

        let stack = UIStackView(arrangedSubviews: [row1, row2, row3])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        featuresCard.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: featuresCard.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: featuresCard.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: featuresCard.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: featuresCard.bottomAnchor, constant: -12)
        ])
    }

    private func makeFeatureRow(icon: String, text: String) -> UIStackView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.33, alpha: 1)
        label.numberOfLines = 1

        let row = UIStackView(arrangedSubviews: [iconView, label])
        row.axis = .horizontal
        row.spacing = 10
        row.alignment = .center
        return row
    }

    private func setupConstraints() {
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safe.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heroImageView.heightAnchor.constraint(equalToConstant: 300),

            welcomeSmallLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 16),
            welcomeSmallLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            welcomeSmallLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: welcomeSmallLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            featuresCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            featuresCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            featuresCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            getStartedButton.topAnchor.constraint(equalTo: featuresCard.bottomAnchor, constant: 24),
            getStartedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            getStartedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            getStartedButton.heightAnchor.constraint(equalToConstant: 52),

            loginButton.topAnchor.constraint(equalTo: getStartedButton.bottomAnchor, constant: 12),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 44),

            footerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            footerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            footerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func setupActions() {
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    // MARK: - Actions (programmatic navigation via WelcomeRouter)

    @objc private func getStartedTapped() {
        // Requirement: Get Started -> Login (first time / new user / after logout)
        WelcomeRouter.shared.navigateToLogin(from: self)
    }

    @objc private func loginTapped() {
        WelcomeRouter.shared.navigateToLogin(from: self)
    }
}
