import UIKit

class AddStudentViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Outlets (connected in storyboard)
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarCameraButton: UIButton!
    @IBOutlet weak var avatarContainerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameCardView: UIView!
    @IBOutlet weak var emailCardView: UIView!
    @IBOutlet weak var courseCardView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var studentToEdit: StudentModel?
    
    // MVVM: ViewModel handles validation + Core Data save + dummy GalleryImageName generation
    var viewModel = AddStudentViewModel()
    var onSave: ((StudentModel) -> Void)?
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 24
        }
        setupEditModeIfNeeded()
    }
    
    private func setupEditModeIfNeeded() {
        guard let student = studentToEdit else { return }
        
        titleLabel.text = "Edit Student"
        nameTextField.text = student.name
        emailTextField.text = student.email
        courseTextField.text = student.course
        
        if let imageData = student.profileImageData {
            avatarImageView.image = UIImage(data: imageData)
            selectedImage = UIImage(data: imageData)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Small polish that storyboard can't do
        AddStudentSheet.styleHandle(handleView)
        AddStudentSheet.styleAvatar(avatarImageView, container: avatarContainerView, cameraButton: avatarCameraButton)
        AddStudentSheet.styleCard(nameCardView)
        AddStudentSheet.styleCard(emailCardView)
        AddStudentSheet.styleCard(courseCardView)
        AddStudentSheet.stylePrimaryButton(saveButton)
    }
    
    // MARK: - Actions
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            selectedImage = image
            avatarImageView.image = image
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.clipsToBounds = true
        }
        dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let course = courseTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if let error = viewModel.validate(name: name, course: course, email: email) {
            showAlert(title: "Missing Information", message: error)
            return
        }
        
        guard let student = viewModel.saveOrUpdate(
                existingObjectID: studentToEdit?.objectID,
                name: name,
                course: course,
                email: email,
                image: selectedImage
            ) else {
                showAlert(title: "Error", message: "Failed to save student details")
                return
            }
        
        onSave?(student)
        dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
