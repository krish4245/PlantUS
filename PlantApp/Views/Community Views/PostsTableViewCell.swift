
//postsTableViewCell.swift
//garden_app

//Created by SDC-USER on 25/11/25.



import UIKit

class PostsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionUsernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    var currentPost: Post?
    
    // Closures for button taps
    var onAvatarTapped: (() -> Void)?
    var onLikeTapped: ((Bool, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        selectionStyle = .none
       
        
        if let avatar = avatarImageView {

            avatar.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
            tap.cancelsTouchesInView = false
            avatar.addGestureRecognizer(tap)
        }
        
    }
    @objc func avatarTapped() {
        onAvatarTapped?()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    
    
        guard var post = currentPost else { return }
        
        if post.isLiked {
                    post.isLiked = false
                    post.likesCount = max(0, post.likesCount - 1)
                } else {
                    post.isLiked = true
                    post.likesCount += 1
                }
                
                self.currentPost = post
                
                updateLikeUI(isLiked: post.isLiked, count: post.likesCount)
                //update comntroller
        
                onLikeTapped?(post.isLiked, post.likesCount)
    }

    func configure(with post: Post) {
        
        self.currentPost = post
        
        usernameLabel.text = post.author?.username
        captionUsernameLabel.text = post.author?.username
        captionLabel.text = post.caption
        timeLabel.text = "2h ago" // Replace with real date logic later
        
        // Load Images
        postImageView.configureImage(with: post.postImageString)

        
        updateLikeUI(isLiked: post.isLiked, count: post.likesCount)
    }
    
    func updateLikeUI(isLiked: Bool, count : Int) {
        print("DEBUG: Liked? \(isLiked) Count: \(count)") // Check your console!
        let imageName = isLiked ? "heart.fill" : "heart"
        let color = isLiked ? UIColor.systemRed : UIColor.label
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.setImage(image, for: .highlighted)
        likeButton.tintColor = color
        
        if count == 0 {
                     likesCountLabel.text = "0 likes"
                } else if count == 1 {
                     likesCountLabel.text = "1 like"
                } else {
                     likesCountLabel.text = "\(count) likes"
                }
    }
}
