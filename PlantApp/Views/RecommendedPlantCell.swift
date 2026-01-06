//
//  RecommendedPlantCell.swift
//  Sample_searchPage
//
//  Created by vedant on 31/12/25.
//

import UIKit

class RecommendedPlantCell: UICollectionViewCell {
    
    static let identifier = "RecommendedPlantCell"

    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
          contentView.backgroundColor = .systemBackground

          contentView.layer.cornerRadius = 16
          contentView.layer.masksToBounds = true

          //  subtle border
          contentView.layer.borderWidth = 1
          contentView.layer.borderColor = UIColor.separator.cgColor
        
    }
    
    func configure(with plant: PlantModel_Ved) {
           nameLabel.text = plant.name
           tagLabel.text = plant.tagline
           plantImageView.image = UIImage(named: plant.imageName)
       }
}
