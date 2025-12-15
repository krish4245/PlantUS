//
//  CommunityViewController.swift
//  garden_app
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class CommunityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadDummyPosts()
    }
    
    private func setupTable() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.separatorStyle = .none
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 400
    }
    
    
    private func loadDummyPosts() {
        let vedant = User(name: "Vedant_Arya", avatarImageName: nil)
        let plantParent = User(name: "Plantparentpro", avatarImageName: nil)
        let shubham = User(name: "Shubham Rajput", avatarImageName: nil)

        posts = [
            Post(
                user: vedant,
                imageName: "plant_vedant",   // add these to Assets.xcassets
                caption: "New leaf alert! 🌿 Can’t believe how fast it’s growing!",
                timeAgo: "2h"
            ),
            Post(
                user: plantParent,
                imageName: "plant_balcony",
                caption: "Watered and happy again 💧✨ #PlantParent",
                timeAgo: "5h"
            ),
            Post(
                user: shubham,
                imageName: "plant_shubham",
                caption: "Sunday = watering + talking to my plants day 🌼💬",
                timeAgo: "1d"
            )
        ]

        postsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell",
                                                 for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.configure(with: post)
        cell.delegate = self

        return cell
    }
}

extension CommunityViewController: PostsTableViewCellDelegate {
    func communityPostCellDidTapLike(_ cell: PostsTableViewCell) {
        if let indexPath = postsTableView.indexPath(for: cell) {
            print("Like tapped at row \(indexPath.row)")
            // Toggle like state or handle action here if your Post model supports it
        } else {
            print("Like tapped")
        }
    }
    
    func communityPostCellDidTapComment(_ cell: PostsTableViewCell) {
        guard let indexPath = postsTableView.indexPath(for: cell) else {
            print("Comment tapped (no indexPath)")
            return
        }
        let selectedPost = posts[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "CommentsViewController"
        ) as! CommentsViewController

        vc.post = selectedPost

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        present(vc, animated: true)
    }
}
	
