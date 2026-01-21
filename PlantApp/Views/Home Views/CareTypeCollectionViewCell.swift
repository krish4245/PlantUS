//
//  CareTypeCollectionViewCell.swift
//  PlantApp
//
//  Created by SDC-USER on 07/01/26.
//

import UIKit

class CareTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var containerView: UIView!

        override func awakeFromNib() {
            super.awakeFromNib()

            containerView.layer.cornerRadius = 18
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            containerView.backgroundColor = .clear
            contentView.layer.cornerRadius = 20
            contentView.layer.masksToBounds = true
        }
 
    


        func configure(title: String, icon: UIImage?, selected: Bool) {
            titleLabel.text = title
            iconImageView.image = icon

            if selected {
                containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
                containerView.layer.borderColor = UIColor.systemGreen.cgColor
            } else {
                containerView.backgroundColor = .clear
                containerView.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
}
