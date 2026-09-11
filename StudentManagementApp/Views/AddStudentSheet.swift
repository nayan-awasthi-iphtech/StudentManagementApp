import UIKit

// Simple helper for visuals that storyboard can't do
enum AddStudentSheet {

    static func styleHandle(_ view: UIView?) {
        view?.backgroundColor = .tertiaryLabel.withAlphaComponent(0.35)
        view?.layer.cornerRadius = 2.5
        view?.layer.masksToBounds = true
    }

    static func styleCard(_ view: UIView?) {
        guard let v = view else { return }
        v.backgroundColor = UIColor(red: 1, green: 0.992, blue: 0.96, alpha: 1)
        v.layer.cornerRadius = 14
        v.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        v.layer.borderWidth = 1
        v.layer.shadowColor = UIColor.label.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 6
        v.layer.masksToBounds = false
    }

    static func styleAvatar(_ imageView: UIImageView?, container: UIView?, cameraButton: UIButton?) {
        guard let iv = imageView else { return }
        iv.layer.cornerRadius = iv.frame.width / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        cameraButton?.layer.cornerRadius = 14
        cameraButton?.clipsToBounds = true
    }

    static func stylePrimaryButton(_ button: UIButton?) {
        button?.layer.cornerRadius = 28
        button?.layer.masksToBounds = true
        button?.backgroundColor = .black
        button?.setTitleColor(.white, for: .normal)
    }
}
