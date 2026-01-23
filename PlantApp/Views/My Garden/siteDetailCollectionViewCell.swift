//
//  siteDetailCollectionViewCell.swift
//  PlantApp
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class siteDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    static let identifier = "plantCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyCardStyle()
        //        contentView.layer.cornerRadius = 16
        //        layer.cornerRadius = 16
        //        contentView.layer.masksToBounds = true
        //        
        //        layer.borderWidth = 0.8
        //        layer.borderColor = UIColor.systemGray5.cgColor
        //        
        //        layer.shadowColor = UIColor.black.cgColor
        //               layer.shadowOpacity = 0.08
        //               layer.shadowOffset = CGSize(width: 0, height: 2)
        //               layer.shadowRadius = 6
        //               layer.masksToBounds = false
        // Initialization code
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
    
    
    public  func configure(userPlant: UserPlant) {
        let plantModel = PlantDataSource.shared.plant(for: userPlant.plantId)
        plantNameLabel.text = "\(plantModel?.name ?? "Unknown Plant") "
        
        
        if let imageData = userPlant.imageData,
              let image = UIImage(data: imageData) {
               plantImageView.image = image
           } else if let imageName = plantModel?.imageName {
               plantImageView.image = UIImage(named: imageName)
           } else {
               plantImageView.image = UIImage(systemName: "leaf")
           }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "siteDetailCollectionViewCell", bundle: nil)
    }
}
