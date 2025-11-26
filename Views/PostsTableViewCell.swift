//
//  postsTableViewCell.swift
//  garden_app
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        // card style
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        // avatar circle
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        // image crop
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
    }
    
    func configure(with post: Post) {
        nameLabel.text = post.user.name
        captionLabel.text = post.caption
        
        // image for post
        postImageView.image = UIImage(named: post.imageName)
        
        // avatar: use asset if present, else system icon
        if let avatarName = post.user.avatarImageName,
           let avatar = UIImage(named: avatarName) {
            avatarImageView.image = avatar
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        // you can later toggle likeButton image/state here
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
