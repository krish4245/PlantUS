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
        // Round Avatar
        //profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor

        // Grid Setup
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func checkIsCurrentUser() {
        // 1. Fetch the "Logged In" user (Shubham/u2) from the 'server'

            if let passedUser = self.user {
                // We check: Is the person we clicked (passedUser) the same as me (currentUser)?
                self.isCurrentUser = CommunityDataStore.shared.isCurrentUser(userID: passedUser.id)
            } else {
                // CASE B: We clicked the "Profile" tab (No user passed)
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
            // STATE: MY PROFILE
            // Hide the "Add/Message" buttons.
            otherUserButtonsStack.isHidden = true

            // Show Tabs
            setupTabs(forCurrentUser: true)

        } else {
            // STATE: OTHER PROFILE
            // Show the "Add/Message" buttons
            otherUserButtonsStack.isHidden = false

            // Setup Tabs (Only Posts)
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
        let storyboard = UIStoryboard(name: "Screens", bundle: nil)
        // Make sure you give your Edit VC this ID in Storyboard!
        if let editVC = storyboard.instantiateViewController(
            withIdentifier: "EditProfileViewController"
        ) as? EditProfileViewController {
            editVC.user = self.user
            present(editVC, animated: true)
        }
    }

    // MARK: - CollectionView Grid
    // (Keep your existing CollectionView code here - numberOfItems, cellForItemAt, etc.)
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
