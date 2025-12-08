import UIKit
import PhotosUI

class NewPostViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture() // <--- New Function
        
        // Fetch User
        CommunityDataStore.shared.fetchAllUsers { users in
            self.currentUser = users.first
        }
    }
    
    func setupUI() {
        // Style the placeholder
        selectedImageView.layer.cornerRadius = 12
        selectedImageView.clipsToBounds = true
        selectedImageView.backgroundColor = .systemGray6
        
        // Set placeholder icon
        selectedImageView.image = UIImage(systemName: "photo.badge.plus")
        selectedImageView.contentMode = .center // Keep icon centered and small
        selectedImageView.tintColor = .systemGray // Make icon gray
    }
    
    // MARK: - Setup Tap Gesture
    func setupTapGesture() {
        // 1. Create the gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        // 2. Add it to the image view
        selectedImageView.addGestureRecognizer(tapGesture)
        
        // 3. Make sure interaction is enabled (Just in case you missed it in Storyboard)
        selectedImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc func imageTapped() {
        // This runs when you click the Image View!
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        // Validation: Don't share if it's still the placeholder icon
        if selectedImageView.image == UIImage(systemName: "photo.badge.plus") {
            print("Please pick an image first!")
            return
        }
        
        guard let image = selectedImageView.image else { return }
        guard let caption = captionTextField.text else { return }
        guard let user = currentUser else { return }
        
        shareButton.setTitle("Posting...", for: .normal)
        
        CommunityDataStore.shared.addNewPost(caption: caption, image: image, currentUser: user) { success in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - Gallery Delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let result = results.first {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let selectedImage = image as? UIImage {
                            
                            // UPDATE UI: Change mode to Fill so the photo looks good
                            self?.selectedImageView.contentMode = .scaleAspectFill
                            self?.selectedImageView.image = selectedImage
                        }
                    }
                }
            }
        }
    }
}
