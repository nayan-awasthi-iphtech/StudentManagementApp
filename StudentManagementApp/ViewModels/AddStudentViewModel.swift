import UIKit
import CoreData

class AddStudentViewModel {
    
    func validate(name: String, course: String, email: String) -> String? {
        if name.isEmpty && course.isEmpty {
            return "Please enter both student name and course."
        }
        if name.isEmpty {
            return "Please enter the student's name."
        }
        if course.isEmpty {
            return "Please enter the student's course."
        }
        if !email.isEmpty && !isValidEmail(email) {
            return "Please enter a valid email address."
        }
        return nil
    }
    
    func saveOrUpdate(existingObjectID: NSManagedObjectID?, name: String, course: String, email: String, image: UIImage?) -> StudentModel? {
            let imageData = image?.jpegData(compressionQuality: 0.8)
            
            if let objectID = existingObjectID {
                let success = CoreDataManager.shared.updateStudent(
                    objectID: objectID,
                    name: name,
                    course: course,
                    email: email,
                    profileImageData: imageData
                )
                
                if success {
                    return StudentModel(
                        name: name,
                        course: course,
                        profileImageName: imageData,
                        galleryImages: [],
                        email: email,
                        objectID: objectID
                    )
                } else {
                    return nil
                }
            }
            
            guard let savedEntity = CoreDataManager.shared.saveStudent(
                name: name,
                course: course,
                email: email,
                profileImageData: imageData
            ) else {
                return nil
            }
            
            return savedEntity.toModel()
        }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
