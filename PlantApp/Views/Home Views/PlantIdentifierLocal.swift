//
//  PlantIdentifierLocal.swift
//  PlantApp
//
//  Created by SDC-USER on 10/12/25.
//


// PlantIdentifierLocal.swift
import UIKit
import Vision
import CoreML


final class PlantIdentifierLocal {
    private let vnModel: VNCoreMLModel
    
    
    init?(modelFileName: String = "MyImageClassifier_2") {
        // Look for a compiled model in the app bundle (.mlmodelc) or the .mlmodel
        
        guard let modelURL = Bundle.main.url(forResource: modelFileName, withExtension: "mlmodelc")
                ?? Bundle.main.url(forResource: modelFileName, withExtension: "mlmodel") else {
            print("PlantIdentifierLocal: model file \(modelFileName) not found in bundle")
            return nil
        }
        do {
            let mlmodel = try MLModel(contentsOf: modelURL)
            self.vnModel = try VNCoreMLModel(for: mlmodel)
        } catch {
            print("PlantIdentifierLocal: failed to load model at \(modelURL):", error)
            return nil
        }
    }
    
    /// Identify image. Returns array of (label, confidence) sorted by confidence descending.
    func identify(image: UIImage, completion: @escaping ([(label: String, confidence: Float)]) -> Void) {
        guard let cg = (image.cgImage ?? image.downsampled(maxSide: 1024)?.cgImage) else {
            completion([])
            return
        }
        
        let request = VNCoreMLRequest(model: vnModel) { req, error in
            if let err = error {
                print("VNCoreMLRequest error:", err)
                DispatchQueue.main.async { completion([]) }
                return
            }
            guard let results = req.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            let mapped = results.map { (label: $0.identifier, confidence: $0.confidence) }
            DispatchQueue.main.async { completion(mapped) }
        }
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Vision perform error:", error)
                DispatchQueue.main.async { completion([]) }
            }
        }
    }
}

fileprivate extension UIImage {
    func downsampled(maxSide: CGFloat) -> UIImage? {
        let aspect = size.width / size.height
        var newSize: CGSize
        if size.width >= size.height {
            newSize = CGSize(width: maxSide, height: maxSide / aspect)
        } else {
            newSize = CGSize(width: maxSide * aspect, height: maxSide)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
