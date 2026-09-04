import UIKit

class StudentGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    private var emptyLabel: UILabel!
    
    var student: StudentModel? {
        didSet {
            if let student = student {
                viewModel = StudentGalleryViewModel(student: student)
            }
        }
    }
    private var viewModel: StudentGalleryViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupEmptyLabel()
        setupNavigationBar()
        bindViewModel()
        
        viewModel?.loadGallery()
    }

    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = viewModel?.title ?? "Gallery"
        navigationItem.largeTitleDisplayMode = .never
        
        // Top right Add Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addImageTapped)
        )
    }

    private func setupEmptyLabel() {
        emptyLabel = UILabel()
        emptyLabel.text = "Please add first image to your image gallery"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func bindViewModel() {
        viewModel?.onReload = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let vm = self.viewModel else { return }
                self.emptyLabel.isHidden = !vm.isEmpty
                self.collectionView.isHidden = vm.isEmpty
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc private func addImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            viewModel?.addImage(editedImage)
        }
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? StudentGalleryCollectionView else {
            return UICollectionViewCell()
        }
        
        if let data = viewModel?.imageData(at: indexPath.item) {
            cell.galleryImageView.image = UIImage(data: data)
            cell.galleryImageView.contentMode = .scaleAspectFill
            cell.galleryImageView.clipsToBounds = true
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let padding: CGFloat = 8
        let totalPadding = padding * (columns + 1)
        let availableWidth = collectionView.frame.width - totalPadding
        let itemWidth = availableWidth / columns
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
