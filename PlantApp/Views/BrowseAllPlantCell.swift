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
        applyCardStyle()
        // Initialization code
        backgroundColor = .clear
          contentView.backgroundColor = .systemBackground

          contentView.layer.cornerRadius = 16
          contentView.layer.masksToBounds = true

        contentView.layer.borderWidth = 0.5
          contentView.layer.borderColor = UIColor.separator.cgColor

          plantImageView.layer.cornerRadius = 10
          plantImageView.clipsToBounds = true

        contentView.layer.masksToBounds = false
              
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
