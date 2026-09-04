//
//  StudentTableViewCell.swift
//  StudentManagementApp
//
//  Created by iPHTech 30 on 25/08/26.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = false
        cardView.backgroundColor = .secondarySystemGroupedBackground
        
        nameLabel.textColor = .label
        courseLabel.textColor = .secondaryLabel
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        updateShadowForCurrentTheme()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 12).cgPath
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateShadowForCurrentTheme()
    }

    func configure(with student: StudentModel) {
        nameLabel.text = student.name
        courseLabel.text = student.course
        if let data = student.profileImageData {
            profileImageView.image = UIImage(data: data)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    
    private func updateShadowForCurrentTheme() {
        let isDark = traitCollection.userInterfaceStyle == .dark

        cardView.layer.shadowColor = UIColor.label.cgColor
        cardView.layer.shadowOpacity = isDark ? 0.03 : 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 6
    }
}
