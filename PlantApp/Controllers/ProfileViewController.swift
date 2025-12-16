//
//  ProfileViewController.swift
//  garden_app
//
//  Created by SDC-USER on 09/12/25.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!

    // The Stack for OTHERS (Add/Message).
    // We don't have an Edit button anymore, it's in the menu.
    @IBOutlet weak var otherUserButtonsStack: UIStackView!
    
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    // The Menu Button (Top Right Ellipsis)
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var postsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Data
    var user: User?
    var isCurrentUser: Bool = false
    private var userPosts: [Post] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkIsCurrentUser()
        updateUI()

        //        otherUserButtonsStack.isHidden = true
        //        navigationItem.rightBarButtonItem = nil
        //    }
        //
        //    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(animated)
        //        loadData()
    }

    func setupUI() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor

        // Grid Setup
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func checkIsCurrentUser() {
        // 1. Fetch the "Logged In" user (Shubham/u2)
            if let passedUser = self.user {
                self.isCurrentUser = CommunityDataStore.shared.isCurrentUser(userID: passedUser.id)
            } else {

                self.isCurrentUser = true
            }
        
    }

    func updateUI() {
        guard let user = user else { return }

        print(isCurrentUser, "Current USER")
        
        // 1. Fill Text
        nameLabel.text = user.name
        handleLabel.text = "@\(user.username)"
        statsLabel.text = user.searchSubtitle
        profileImageView.configureImage(with: user.profileImageString)

        navigationItem.rightBarButtonItem = menuButton

        // 2. Toggle UI based on Identity
        if isCurrentUser {
            otherUserButtonsStack.isHidden = true
            setupTabs(forCurrentUser: true)

        } else {
            otherUserButtonsStack.isHidden = false
            setupTabs(forCurrentUser: false)
        }

        // 3. Fetch Posts
        CommunityDataStore.shared.fetchPosts(forUserId: user.id) {
            [weak self] posts in
            self?.userPosts = posts
            self?.collectionView.reloadData()
        }
        
        setupMenu()
    }
    
    
    func updateButtonState() {
            guard let user = user else { return }
            
            if user.isFriend {
                addFriendButton.isHidden = true
                
                messageButton.isEnabled = true
                messageButton.backgroundColor = UIColor.systemGreen
                messageButton.alpha = 1.0
            } else {
                addFriendButton.isHidden = false
                addFriendButton.setTitle("Add Friend", for: .normal)
                addFriendButton.backgroundColor = UIColor.systemGreen
                addFriendButton.setTitleColor(.white, for: .normal)
                addFriendButton.isEnabled = true
                
                messageButton.isEnabled = false
                messageButton.backgroundColor = UIColor.systemGray4
                messageButton.alpha = 0.6
            }
        }
        
        // MARK: - Actions
        
        @IBAction func addFriendTapped(_ sender: UIButton) {
            guard let user = user else { return }
            
            // 1. Update Database
            CommunityDataStore.shared.addFriend(userId: user.id)
            
            // 2. Update Local Model
            self.user?.isFriend = true
            
            // 3. Refresh UI
            UIView.animate(withDuration: 1.0) {
                self.addFriendButton.setTitle("Added ✓", for: .normal)
                self.addFriendButton.backgroundColor = UIColor.systemGray5
                self.addFriendButton.setTitleColor(.systemGray, for: .normal)
                self.addFriendButton.isEnabled = false
                self.updateButtonState()
                
                self.messageButton.isEnabled = true
                self.messageButton.backgroundColor = UIColor.systemGreen
                self.messageButton.alpha = 1.0
            }
            print("Friend Added: \(user.name)")
        }
        
        @IBAction func messageTapped(_ sender: UIButton) {
            print("Opening Chat with \(user?.name ?? "User")...")
             performSegue(withIdentifier: "OpenChat", sender: self.user)
                }
    
    // This is the bridge that passes data to the next screen
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "OpenChat" {
                // 1. Check if destination is ChatViewController
                if let chatVC = segue.destination as? ChatViewController {
                    
                    // 3. Catch the User object sent from messageTapped
                    if let userToPass = sender as? User {
                        chatVC.user = userToPass // <--- Handing over the data!
                    }
                }
            }
        }

    func setupTabs(forCurrentUser: Bool) {
        postsSegmentedControl.removeAllSegments()
        postsSegmentedControl.insertSegment(
            withTitle: "Posts",
            at: 0,
            animated: false
        )

        if forCurrentUser {
            postsSegmentedControl.insertSegment(
                withTitle: "Saved",
                at: 1,
                animated: false
            )
            postsSegmentedControl.isEnabled = true
        } else {
            // Others usually just see posts
            postsSegmentedControl.isEnabled = false
        }
        postsSegmentedControl.selectedSegmentIndex = 0
    }

    // MARK: - Actions


    
    func setupMenu() {
            // 1. Define Actions for "My Profile"
            let editAction = UIAction(title: "Edit Profile", image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.openEditProfile()
            }
            
            let settingsAction = UIAction(title: "Settings", image: UIImage(systemName: "gearshape")) { _ in
                print("Settings tapped")
            }
            
            // 2. Define Actions for "Other Profiles"
            
            let blockAction = UIAction(title: "Block", image: UIImage(systemName: "hand.raised.slash"), attributes: .destructive) { _ in
                print("Block tapped")
            }
            
            let shareAction = UIAction(title: "Share Profile", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                print("Share tapped")
            }
            
            // 3. Choose which menu to show
            var menuItems: [UIAction] = []
            
            if isCurrentUser {
                menuItems = [editAction, settingsAction]
            } else {
                menuItems = [shareAction, blockAction]
            }
            
            // 4. Create and Attach the Menu
            let demoMenu = UIMenu(title: isCurrentUser ? "My Options" : "User Options", children: menuItems)
            
            menuButton.menu = demoMenu
        }

    func openEditProfile() {
        // Standard code to open the Edit Screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Make sure you give your Edit VC this ID in Storyboard!
        if let editVC = storyboard.instantiateViewController(
            withIdentifier: "EditProfileViewController"
        ) as? EditProfileViewController {
            editVC.user = self.user
            present(editVC, animated: true)
        }
    }

    // MARK: - CollectionView Grid
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return userPosts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProfileGridCell",
                for: indexPath
            ) as! ProfileGridCell
        let post = userPosts[indexPath.row]
        cell.imageView.configureImage(with: post.postImageString)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
}
