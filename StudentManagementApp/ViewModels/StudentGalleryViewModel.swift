import UIKit
import CoreData

final class StudentGalleryViewModel {

    private let student: StudentModel
    private(set) var galleryImagesData: [Data] = []
    
    var onReload: (() -> Void)?

    init(student: StudentModel) {
        self.student = student
    }

    var title: String { "\(student.name)'s Gallery" }
    var numberOfItems: Int { galleryImagesData.count }
    var isEmpty: Bool { galleryImagesData.isEmpty }

    func loadGallery() {
        guard let objectID = student.objectID,
              let fetchedStudent = try? CoreDataManager.shared.viewContext.existingObject(with: objectID) as? Student,
              let gallerySet = fetchedStudent.student_gallery as? Set<GalleryImageName> else {
            galleryImagesData = []
            onReload?()
            return
        }

        galleryImagesData = gallerySet.compactMap { $0.image }
        onReload?()
    }

    func imageData(at index: Int) -> Data {
        return galleryImagesData[index]
    }

    func addImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        if CoreDataManager.shared.addGalleryImage(to: student.objectID, imageData: data) {
            loadGallery()
        }
    }
}
