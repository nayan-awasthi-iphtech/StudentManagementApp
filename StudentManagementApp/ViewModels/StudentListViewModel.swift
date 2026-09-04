import Foundation
import CoreData

final class StudentListViewModel {
    
    private(set) var students: [StudentModel] = []
    var onReload: (() -> Void)?
    
    func loadStudents() {
        fetchAndRefresh()
    }
    
    func numberOfRows() -> Int {
        return students.count
    }
    
    func student(at index: Int) -> StudentModel {
        return students[index]
    }
    
    func delete(at index: Int) {
        let studentToDelete = students[index]
        
        if CoreDataManager.shared.deleteStudent(objectID: studentToDelete.objectID) {
            students.remove(at: index)
            onReload?()
        }
    }
    
    func addStudentDidSave() {
        fetchAndRefresh()
    }
    
    func deleteStudent(at index: Int) {
        guard index >= 0 && index < students.count else { return }
        
        let studentToDelete = students[index]
        
        _ = CoreDataManager.shared.deleteStudent(objectID: studentToDelete.objectID)
        
        students.remove(at: index)
        
        onReload?()
    }
    
    private func fetchAndRefresh() {
        let entities = CoreDataManager.shared.fetchAllStudents()
        students = entities.map { $0.toModel() }
        onReload?()
    }
}
