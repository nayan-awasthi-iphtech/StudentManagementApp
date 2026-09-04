//
//  StudentTableViewCell.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 25/08/26.
//

import UIKit

class StudentGalleryCollectionView: UICollectionViewCell {
    @IBOutlet weak var galleryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        galleryImageView.contentMode = .scaleAspectFill
        galleryImageView.clipsToBounds = true
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
