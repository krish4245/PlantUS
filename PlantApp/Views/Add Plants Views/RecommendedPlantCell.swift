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
        applyCardStyle()
        backgroundColor = .clear
          contentView.backgroundColor = .systemBackground

          contentView.layer.cornerRadius = 16
          contentView.layer.masksToBounds = true

          //  subtle border
        contentView.layer.borderWidth = 0.5
          contentView.layer.borderColor = UIColor.systemGray6.cgColor
        
        
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
           nameLabel.text = plant.name
           tagLabel.text = plant.tagline
           plantImageView.image = UIImage(named: plant.imageName)
       }
}
