//
//  CameraOptionViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit
import PhotosUI


class CameraOptionViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,PHPickerViewControllerDelegate{
    
    var answers: AddPlantAnswerModel!
    let siteStore = SiteStore.shared
    //    let plantStore = PlantStore(siteStore: SiteStore())
    
    
    @IBOutlet weak var photoBtn: UIButton!
    
    @IBOutlet weak var plantImageView: UIImageView!
   
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupImageTapGesture()

    }
    
    // MARK: - Add Tap Gesture to ImageView
       func setupImageTapGesture() {
           plantImageView.isUserInteractionEnabled = true
           let tap = UITapGestureRecognizer(target: self, action: #selector(showImagePickerOptions))
           plantImageView.addGestureRecognizer(tap)
       }
    
    
    // MARK: - Show Action Sheet
        @objc func showImagePickerOptions() {
            let alert = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            present(alert, animated: true)
        }
    
    // MARK: - Open Camera
       func openCamera() {
           guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
               print("Camera not available")
               return
           }

           let picker = UIImagePickerController()
           picker.sourceType = .camera
           picker.delegate = self
           present(picker, animated: true)
       }
    
    func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
  
    
     // MARK: - Gallery Image Selected (PHPicker)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                if let img = image as? UIImage {
                    self.updateSelectedImage(img)
                }
            }
        }
    }
    
    // MARK: - Update UI + Save to answers
     func updateSelectedImage(_ image: UIImage) {
         plantImageView.image = image                                          // ⭐ Show preview
         answers.plantImageData = image.jpegData(compressionQuality: 0.8)      // ⭐ Save image
         print("📸 Image saved in answers")
     }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let siteName = answers.selectedSite else { return }
        guard let icon = answers.selectedIcon else { return }
        let siteColor = UIColor.systemGreen   // can change later
        
        let plantCountToAdd = answers.plantNumber ?? 1
       
        print("➡️ Adding \(plantCountToAdd) plants to: \(siteName)")
        
        // If site does NOT exist → create it
        if !siteStore.sites.contains(where: { $0.name.lowercased() == siteName.lowercased() }) {
            
            // 3️⃣ Create the new site
            siteStore.addSite(
                name: siteName,
                color: siteColor,
                icon: icon
            )
            
            print("🌱 New site saved:", siteName)
            
        } else {
            print("⚠️ Site already exists, not creating again")
            
        }
        
        siteStore.addPlants(to: siteName, count: plantCountToAdd )
        
        // 4️⃣ Now get the saved site (to get its ID)
        guard let savedSite = siteStore.sites.first(where: { $0.name == siteName }) else { return }
        
        let plant = Plant_2(
            name: answers.plantName ?? "Unnamed Plant",
            siteID: savedSite.id,                 // 🔥 link plant → site
            imageData: answers.plantImageData,
            lightRequirement: answers.lightRequirement,
            watering: answers.watering,
            repotting: answers.repotting,
            quantity: answers.plantNumber ?? 1
        )
        
        PlantStore.shared.addPlant(plant)
        print("🌿 Plant saved:", plant.name)
  
        //        // 6️⃣ Save plant
        //          plantStore.addPlant(plant)
        //
        //          print("🌿 Plant saved:", plant.name)
        //    }
        
        navigationController?.popToRootViewController(animated: true)

        
        
    }
}
