//
//  GardenSpaceCellCollectionViewCell.swift
//  PlantApp
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class GardenSpaceCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
       @IBOutlet weak var titleStripView: UIView!
       @IBOutlet weak var titleLabel: UILabel!

       override func awakeFromNib() {
           super.awakeFromNib()

           // Card style
           contentView.layer.cornerRadius = 24
           contentView.layer.masksToBounds = true

           // drop shadow on the cell itself (optional)
           layer.shadowColor = UIColor.black.cgColor
           layer.shadowOpacity = 0.08
           layer.shadowRadius = 10
           layer.shadowOffset = CGSize(width: 0, height: 4)
           layer.masksToBounds = false

           cardImageView.contentMode = .scaleAspectFill
           cardImageView.clipsToBounds = true

           titleStripView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
           titleLabel.textColor = .white
           titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
       }

       func configure(name: String, image: UIImage?) {
           titleLabel.text = name
           cardImageView.image = image
       }
}
