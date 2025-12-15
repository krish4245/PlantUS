//
//  postsTableViewCell.swift
//  garden_app
//
//  Created by SDC-USER on 25/11/25.
//

//
//  PostsTableViewCell.swift
//  garden_app
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel! // Renamed from nameLabel to match Model
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!     // Added this because Controller needs it
    @IBOutlet weak var cardView: UIView!
    
    // Buttons (Actions)
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var onAvatarTapped: (() -> Void)?
    var onLikeTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        // Card Styling
        if let card = cardView {
            card.layer.cornerRadius = 10
            card.layer.masksToBounds = false
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.08
            card.layer.shadowRadius = 8
            card.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        
        // Avatar Styling
        if let avatar = avatarImageView {
            avatar.layer.cornerRadius = 10
            avatar.clipsToBounds = true
            
            // 2. ENABLE INTERACTION
        avatar.isUserInteractionEnabled = true
                        
                        // 3. ADD GESTURE RECOGNIZER
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatar.addGestureRecognizer(tapGesture)
        }
        
        // Image Styling
        if let postImg = postImageView {
            postImg.contentMode = .scaleAspectFill
            postImg.clipsToBounds = true
            postImg.layer.cornerRadius = 10 // Matches card corner radius
            // If you want top corners only to be rounded, you need masked corners,
            // but for now, full rounded looks clean inside the card.
        }
    }
    
    @objc func avatarTapped() {
            onAvatarTapped?()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
            // Trigger the closure so the Controller knows to update data
            onLikeTapped?()
        }
    
    // MARK: - Configuration
    func configure(with post: Post) {
        // 1. Text Data
        // We use safe unwrapping (?) because author might be nil in rare cases
        usernameLabel.text = post.author?.username ?? "Unknown"
        captionLabel.text = post.caption
        
        // 2. Images (Using your new Helper Extension)
        postImageView.configureImage(with: post.postImageString)
        
        updateLikeUI(isLiked: post.isLiked)
        
        if let author = post.author {
            avatarImageView.configureImage(with: author.profileImageString)
        } else {
            // Fallback if no author found
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        // 3. Time (Static for now, but ready for data)
        // You can add logic here like: timeLabel.text = post.timeAgo
        if let timeLbl = timeLabel {
            timeLbl.text = "2h ago"
        }
    }
    
    func updateLikeUI(isLiked: Bool) {
            let imageName = isLiked ? "heart.fill" : "heart"
            let color = isLiked ? UIColor.systemRed : UIColor.label // Red vs Black/White
            
            // Set image and color
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            let image = UIImage(systemName: imageName, withConfiguration: config)
            
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = color
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
