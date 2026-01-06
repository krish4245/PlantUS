//
//  BrowseAllPlantCell.swift
//  Sample_searchPage
//
//  Created by vedant on 31/12/25.
//

import UIKit

final class BrowseAllPlantCell: UICollectionViewCell {
    
    static let identifier = "BrowseAllPlantCell"

    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantTitle: UILabel!
    
    @IBOutlet weak var careLabel: UILabel!
    
    private var plantID: String?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
          contentView.backgroundColor = .systemBackground

          contentView.layer.cornerRadius = 16
          contentView.layer.masksToBounds = true

        contentView.layer.borderWidth = 0.5
          contentView.layer.borderColor = UIColor.separator.cgColor

          plantImageView.layer.cornerRadius = 10
          plantImageView.clipsToBounds = true
//        contentView.layer.cornerRadius = 12
//        plantImageView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.gray.cgColor
              
    }
    
    func configure(with plant: PlantModel_Ved) {
         plantID = plant.id

         plantTitle.text = plant.name
         careLabel.text = "Care: \(plant.careDifficulty.rawValue.capitalized)"
//         lightLabel.text = plant.light
//         waterLabel.text = plant.water

         plantImageView.image = UIImage(named: plant.imageName)
     }
    
    func getPlantID() -> String? {
           return plantID
       }

}
