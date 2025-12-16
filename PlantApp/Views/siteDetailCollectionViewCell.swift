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
        plantImageView.contentMode = .scaleAspectFit
        // Initialization code
    }

}
