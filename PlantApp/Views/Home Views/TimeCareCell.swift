//
//  TimeCareCell.swift
//  PlantApp
//
//  Created by SDC-USER on 13/01/26.
//

import UIKit

class TimeCareCell: UICollectionViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "timeCareCell"
   
    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 16
        
        // Add gradient layer
              contentView.layer.insertSublayer(gradientLayer, at: 0)

              // gradient direction
              gradientLayer.startPoint = CGPoint(x: 0, y: 0)
              gradientLayer.endPoint = CGPoint(x: 1, y: 1)
              gradientLayer.cornerRadius = 16

        
    }
    
    
    override func layoutSubviews() {
           super.layoutSubviews()

           //  must update frame here
           gradientLayer.frame = contentView.bounds

           //  clean shadow path
           layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
       }
    
    func configure(with type: CareType_ved) {
           titleLabel.text = type.title
           iconImageView.image = UIImage(systemName: type.icon)
        gradientLayer.colors = type.gradientColors.map { $0.cgColor }
       }
    
    static func nib() -> UINib {
        return UINib(nibName: "TimeCareCell", bundle: nil)
    }

}
