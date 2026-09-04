import UIKit
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    
    private init() {}
    
    var viewContext: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private var context: NSManagedObjectContext{
        return viewContext
    }
    
    func saveContext(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func registerAdmin(name: String, email: String, password: String) -> Bool {
        if fetchAdmin(byEmail: email) != nil {
            return false
        }
        
        let newAdmin = Admin(context: context)
        newAdmin.id = UUID()
        newAdmin.name = name
        newAdmin.email = email
        newAdmin.password = password
        
        saveContext()
        return true
    }
    
    func fetchAdmin(byEmail email: String) -> Admin? {
        let request: NSFetchRequest<Admin> = Admin.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@", email.lowercased())
        return (try? context.fetch(request))?.first
    }
    
    func saveStudent(name: String, course: String, email: String, profileImageData: Data?) -> Student? {
        let student = Student(context: context)
        student.id = UUID()
        student.name = name
        student.course = course
        student.email = email
        student.profileImage = profileImageData
        
        saveContext()
        return student
    }
    
    func fetchAllStudents() -> [Student] {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
    
    func deleteStudent(objectID: NSManagedObjectID?) -> Bool {
        guard let objectID = objectID,
              let objectToDelete = try? context.existingObject(with: objectID) else {
            return false
        }
        
        context.delete(objectToDelete)
        saveContext()
        return true
    }
    
    func updateStudent(objectID: NSManagedObjectID?, name: String, course: String, email: String, profileImageData: Data?) -> Bool {
        guard let objectID = objectID,
              let student = try? context.existingObject(with: objectID) as? Student else {
            return false
        }
        
        student.name = name
        student.course = course
        student.email = email
        if let profileImageData = profileImageData {
            student.profileImage = profileImageData
        }
        
        saveContext()
        return true
    }
    
    func addGalleryImage(to studentObjectID: NSManagedObjectID?, imageData: Data) -> Bool {
        guard let objectID = studentObjectID,
              let student = try? context.existingObject(with: objectID) as? Student else {
            return false
        }
        
        let galleryItem = GalleryImageName(context: context)
        galleryItem.id = UUID()
        galleryItem.image = imageData
        galleryItem.gallery_student = student
        
        saveContext()
        return true
    }
}
