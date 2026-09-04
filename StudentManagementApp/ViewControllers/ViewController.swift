//
//  ViewController.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 25/08/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var themeBarButtonItem: UIBarButtonItem!
    
    // MVVM: ViewModel owns Core Data fetch
    private let viewModel = StudentListViewModel()
    var students: [StudentModel] { viewModel.students }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        bindViewModel()
        viewModel.loadStudents()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Students (\(students.count))"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.boldSystemFont(ofSize: 25)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncThemeIcon()
        viewModel.loadStudents()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Keep icon in sync when system theme changes and we are in .system mode
        if ThemeManager.shared.current == .system {
            syncThemeIcon()
        }
    }

    private func syncThemeIcon() {
        let windowStyle = view.window?.overrideUserInterfaceStyle ?? ThemeManager.shared.current.userInterfaceStyle
        let resolved = ThemeManager.shared.resolvedStyle(for: traitCollection, windowStyle: windowStyle)
        updateThemeIcon(for: resolved)
    }
    
    private func bindViewModel() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationItem.title = "Students (\(self?.viewModel.numberOfRows() ?? 0))"
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func themeButtonTapped(_ sender: UIBarButtonItem) {
        // Whole-app change via ThemeManager — applies to all windows and persists
        ThemeManager.shared.toggle()
        syncThemeIcon()
    }
    
    private func updateThemeIcon(for style: UIUserInterfaceStyle) {
        let isDark = (style == .dark)
        themeBarButtonItem.image = UIImage(systemName: isDark ? "sun.max.fill" : "moon.circle.fill")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as? StudentTableViewCell else {
            return UITableViewCell()
        }
        let student = viewModel.student(at: indexPath.row)
        cell.configure(with: student)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showStudentGallery", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Student", message: "Are you sure, you want to delete the student", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.deleteStudent(at: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completion) in
            let student = self?.viewModel.student(at: indexPath.row)
            let studentName = student?.name ?? "this student"
            
            let alert = UIAlertController(
                title: "Edit Student",
                message: "Do you want to edit \(studentName)?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                self?.presentEditStudentSheet(at: indexPath)
                completion(true)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))
            
            self?.present(alert, animated: true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [editAction])
        
    }
    
    private func presentEditStudentSheet(at indexPath: IndexPath) {
        guard let addVC = storyboard?.instantiateViewController(withIdentifier: "AddStudentViewController") as? AddStudentViewController else { return }
        
        let studentToEdit = viewModel.student(at: indexPath.row)
        
        addVC.studentToEdit = studentToEdit
        
        addVC.onSave = { [weak self] _ in
            self?.viewModel.loadStudents()
        }
        
        present(addVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStudentGallery",
           let galleryVC = segue.destination as? StudentGalleryViewController {
            let indexPath = (sender as? IndexPath) ?? tableView.indexPathForSelectedRow
            if let indexPath = indexPath {
                galleryVC.student = viewModel.student(at: indexPath.row)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else if segue.identifier == "showAddStudent",
                  let addVC = segue.destination as? AddStudentViewController {
            addVC.onSave = { [weak self] _ in
                self?.viewModel.loadStudents()
            }
        }
    }
    
    // Kept for compatibility if other code calls it
    func addStudent(_ student: StudentModel) {
        viewModel.loadStudents()
    }
}
