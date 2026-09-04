//
//  Students.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 25/08/26.
//

import UIKit

import CoreData

struct StudentModel {
    let name: String
    let course: String
    let profileImageData: Data?
    let GalleryImageNames: [Data]
    let email: String?
    let objectID: NSManagedObjectID?

    init(name: String, course: String, profileImageName: Data? = nil, galleryImages: [Data] = [], email: String? = nil, objectID: NSManagedObjectID? = nil) {
        self.name = name
        self.course = course
        self.profileImageData = profileImageName
        self.GalleryImageNames = galleryImages
        self.email = email
        self.objectID = objectID
    }
}

extension Student {
    func toModel() -> StudentModel {
        let galleries = (student_gallery as? Set<GalleryImageName>)?.compactMap { $0.image } ?? []
        return StudentModel(
            name: name ?? "Unknown",
            course: course ?? "",
            profileImageName: profileImage ,
            galleryImages: galleries,
            email: email,
            objectID: objectID
        )
    }
}
