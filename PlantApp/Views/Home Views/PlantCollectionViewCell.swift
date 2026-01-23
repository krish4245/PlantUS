//
//  PlantColeectionViewCellCollectionViewCell.swift
//  PlantApp
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

class PlantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    
    
    private var imageTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyCardStyle()
        
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
//        plantImageView.layer.cornerRadius = 16
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        plantImageView.image = nil
        nameLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func applyCardStyle() {
        layer.cornerRadius = 16
        backgroundColor = .systemBackground
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 6)
        
        layer.masksToBounds = false
    }
    
    //    func configure(with plant: Plant) {
    //        nameLabel.text = plant.name
    //        subtitleLabel.text = plant.subtitle
    //
    //        if let localImage = UIImage(named: plant.imageName) {
    //            plantImageView.image = localImage
    //            return
    //        } else {
    //            // Debug aid: see which names fail
    //            print("DEBUG: UIImage(named:) failed for asset '\(plant.imageName)'")
    //            plantImageView.image = UIImage(named: plant.imageName)
    //        }
    //
    //    //If plant.imageName is a valid URL (contains http:// or https://)
    //    // Downloads the image asynchronously
    //    // Sets it on the main thread when received
    //    //Stores the task in imageTask (likely for cancellation)
    //        
    //        if let url = URL(string: plant.imageName), url.scheme != nil {
    //            plantImageView.image = nil
    //            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
    //                guard let self = self,
    //                      let data = data,
    //                      let image = UIImage(data: data) else { return }
    //                DispatchQueue.main.async {
    //                    self.plantImageView.image = image
    //                }
    //            }
    //            imageTask?.resume()
    //        } else {
    //            plantImageView.image = nil
    //        }
    //    }
    
    func configure(with plantModel: PlantModel_Ved, userPlant: UserPlant, careType: CareType) {
        nameLabel.text = plantModel.name
        
        
        switch careType {
        case .watering:
            subtitleLabel.text = "Water Today"
        case .trimming:
            subtitleLabel.text = "Prune Today"
        case .fertilizing:
            subtitleLabel.text = "Fertilize Today"
        case .repotting:
            subtitleLabel.text = "Repot Soon"
        }
        
        if let imageData = userPlant.imageData,
             let image = UIImage(data: imageData) {
              plantImageView.image = image
          } else {
              plantImageView.image = UIImage(named: plantModel.imageName)
          }
        
    }
    
    
}
