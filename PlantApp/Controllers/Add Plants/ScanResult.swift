//
//  ScanResult.swift
//  PlantApp
//
//  Created by SDC-USER on 12/01/26.
//

import UIKit
import Vision
import CoreML

class ScanResult: UIViewController {
    
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    var capturedImage: UIImage?
       var plantName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        plantImageView.image = capturedImage
        plantNameLabel.text = "Identifying plant..."

               runMLModel()
        // Do any additional setup after loading the view.
        var capturedImage: UIImage?
        var plantName: String?
    }
    func goToResultScreen(image: UIImage) {
        let vc = storyboard?.instantiateViewController(
            withIdentifier: "ScanResultViewController"
        ) as! ScanResult

        vc.capturedImage = image
//        vc.plantName = "Monstera" // temporary hardcoded name

        navigationController?.pushViewController(vc, animated: true)
    }

    private func runMLModel() {
        guard let image = capturedImage,
              let ciImage = CIImage(image: image) else {
            plantNameLabel.text = "Image error"
            return
        }

        do {
            let model = try VNCoreMLModel(for: MyImageClassifier_2().model)

            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    DispatchQueue.main.async {
                        self.plantNameLabel.text = "Unable to identify"
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.plantNameLabel.text = topResult.identifier
                }
            }

            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                try? handler.perform([request])
            }

        } catch {
            plantNameLabel.text = "ML Model error"
        }
    }

}
