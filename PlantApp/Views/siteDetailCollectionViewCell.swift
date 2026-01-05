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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        // Initialization code
    }
    
    func configure(with userPlant: UserPlant) {
        let plantModel = PlantDataSource.shared.plant(for: userPlant.plantId)
        plantNameLabel.text = plantModel?.name ?? "Unknown Plant"
        
        if let data = userPlant.imageData {
                    plantImageView.image = UIImage(data: data)
                } else if let imageName = plantModel?.imageName {
                    plantImageView.image = UIImage(named: imageName)
                } else {
                    plantImageView.image = UIImage(systemName: "leaf")
                }
    }
}
