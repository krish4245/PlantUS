//
//  PeopleTableViewCell.swift
//  garden_app
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    // Connect these by Control-Dragging from XIB
    //@IBOutlet weak var statusDot: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 1. Make Avatar Circular
        avatarImageView.layer.cornerRadius = 25 // Half of height (50)
        avatarImageView.clipsToBounds = true
        
        // 2. Make Dot Circular
        //statusDot.layer.cornerRadius = 6 // Half of height (12)
        //statusDot.clipsToBounds = true
        
        // 3. Set default dot state
        //statusDot.isHidden = true
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
