//
//  PostTableViewCell.swift
//  garden_app
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
                avatarImageView.clipsToBounds = true

                selectionStyle = .none
        // Initialization code
    }
    
    func configure(with post: Post) {
            nameLabel.text = post.user.name
            captionLabel.text = post.caption

            if let image = UIImage(named: post.imageName) {
                postImageView.image = image
            } else {
                postImageView.image = nil
            }

            avatarImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//    }
//    
//}
