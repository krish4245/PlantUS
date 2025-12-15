//import UIKit
//import PhotosUI
//
//class NewPostViewController: UIViewController, PHPickerViewControllerDelegate {
//
//    @IBOutlet weak var selectedImageView: UIImageView!
//    @IBOutlet weak var captionTextField: UITextField!
//    @IBOutlet weak var shareButton: UIButton!
//    
//    var currentUser: User?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupTapGesture() // <--- New Function
//        
//        // Fetch User
//        CommunityDataStore.shared.fetchAllUsers { users in
//            self.currentUser = users.first
//        }
//    }
//    
//    func setupUI() {
//        // Style the placeholder
//        selectedImageView.layer.cornerRadius = 12
//        selectedImageView.clipsToBounds = true
//        selectedImageView.backgroundColor = .systemGray6
//        
//        // Set placeholder icon
//        selectedImageView.image = UIImage(systemName: "photo.badge.plus")
//        selectedImageView.contentMode = .center // Keep icon centered and small
//        selectedImageView.tintColor = .systemGray // Make icon gray
//    }
//    
//    // MARK: - Setup Tap Gesture
//    func setupTapGesture() {
//        // 1. Create the gesture
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        
//        // 2. Add it to the image view
//        selectedImageView.addGestureRecognizer(tapGesture)
//        
//        // 3. Make sure interaction is enabled (Just in case you missed it in Storyboard)
//        selectedImageView.isUserInteractionEnabled = true
//    }
//    
//    // MARK: - Actions
//    
//    @objc func imageTapped() {
//        // This runs when you click the Image View!
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.selectionLimit = 1
//        
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//    
//    @IBAction func shareTapped(_ sender: UIButton) {
//        // Validation: Don't share if it's still the placeholder icon
//        if selectedImageView.image == UIImage(systemName: "photo.badge.plus") {
//            print("Please pick an image first!")
//            return
//        }
//        
//        guard let image = selectedImageView.image else { return }
//        guard let caption = captionTextField.text else { return }
//        guard let user = currentUser else { return }
//        
//        shareButton.setTitle("Posting...", for: .normal)
//        
//        CommunityDataStore.shared.addNewPost(caption: caption, image: image, currentUser: user) { success in
//            self.dismiss(animated: true)
//        }
//    }
//    
//    @IBAction func closeTapped(_ sender: Any) {
//        dismiss(animated: true)
//    }
//
//    // MARK: - Gallery Delegate
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        
//        if let result = results.first {
//            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                    DispatchQueue.main.async {
//                        if let selectedImage = image as? UIImage {
//                            
//                            // UPDATE UI: Change mode to Fill so the photo looks good
//                            self?.selectedImageView.contentMode = .scaleAspectFill
//                            self?.selectedImageView.image = selectedImage
//                        }
//                    }
//                }
//            }
//        }
//    }
//}


import UIKit
import PhotosUI

class NewPostViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView! // CHANGED from TextField
    @IBOutlet weak var shareButton: UIButton! // The bottom button
    
    // Placeholder text logic
    let placeholderText = "Write a caption..."
    
    var currentUser: User?
    var onPostSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup Image Placeholder
        setupImagePlaceholder()
        setupTapGesture()
        
        //tableView.keyboardDismissMode = .onDrag
        
        // 2. Setup Caption TextView
        setupCaptionTextView()
        
        // 3. Setup Bottom Button
        shareButton.layer.cornerRadius = 25
        shareButton.clipsToBounds = true
        
        // Fetch User
        CommunityDataStore.shared.fetchAllUsers { users in
            self.currentUser = users.first
        }
    }
    
    func setupImagePlaceholder() {
        selectedImageView.layer.cornerRadius = 16
        selectedImageView.clipsToBounds = true
        selectedImageView.backgroundColor = .systemGray6
        selectedImageView.contentMode = .center
        
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        selectedImageView.image = UIImage(systemName: "camera.fill", withConfiguration: config)
        selectedImageView.tintColor = .systemGray3
    }
    
    // MARK: - Caption Logic (Making it look like a Field)
    func setupCaptionTextView() {
        captionTextView.delegate = self
        captionTextView.text = placeholderText
        captionTextView.textColor = .lightGray
        captionTextView.font = UIFont.systemFont(ofSize: 16)
        
        // Remove the default padding so it aligns with the image
        captionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    // TextView Delegate: Clears placeholder when you start typing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .label // Black (or White in Dark Mode)
        }
    }
    
    // TextView Delegate: Puts placeholder back if you type nothing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selectedImageView.addGestureRecognizer(tapGesture)
        selectedImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    
    @objc func imageTapped() {
        // ... (Keep your existing Action Sheet logic here) ...
        let alert = UIAlertController(title: "Add Photo", message: "Choose a source", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in self.openGallery() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // Connect this to the Bottom Green Button
    @IBAction func shareTapped(_ sender: UIButton) {
        // Validation: Check if image is set AND caption is not the placeholder
        if selectedImageView.contentMode == .center {
            showAlert(message: "Please choose a picture first!")
            return}
        if captionTextView.text == placeholderText || captionTextView.text.isEmpty { showAlert(message: "Please write a caption!")
            return}
        
        guard let image = selectedImageView.image, let user = currentUser else { return }
        
        shareButton.isEnabled = false
        shareButton.setTitle("Posting...", for: .normal)
        
        CommunityDataStore.shared.addNewPost(caption: captionTextView.text, image: image, currentUser: user) { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.onPostSuccess?()
                self.dismiss(animated: true)
            }
        }
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Missing Info",message:message,preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Connect this to the Bar Button Item (Top Left X)
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // ... (Keep your existing Camera/Gallery Delegate methods) ...
    // Copy them from the previous message if you deleted them
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera; picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
    func openGallery() {
        var config = PHPickerConfiguration(); config.filter = .images; config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config); picker.delegate = self
        present(picker, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let result = results.first {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async { if let img = image as? UIImage { self?.updateImageView(with: img) } }
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let img = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage { updateImageView(with: img) }
    }
    func updateImageView(with image: UIImage) {
        selectedImageView.contentMode = .scaleAspectFill
        selectedImageView.image = image
    }
}
