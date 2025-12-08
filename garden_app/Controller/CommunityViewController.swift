//
//  CommunityViewController.swift
//  garden_app
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class CommunityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    // MARK: - Data
    // We use the new Post model we created
    private var posts: [Post] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadData()
    }
    
    private func setupTable() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.separatorStyle = .none
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 400
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // 1. Ask the DataStore for posts (Replaces the old dummy function)
        CommunityDataStore.shared.fetchAllPosts { [weak self] downloadedPosts in
            
            // 2. Update the array
            self?.posts = downloadedPosts
            
            // 3. Refresh the UI
            self?.postsTableView.reloadData()
        }
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        
        // --- CONFIGURE CELL ---
        // We configure it manually here since your cell's 'configure' method
        // likely expects the OLD Post struct and might break.
        
        // 1. Text Data
        cell.usernameLabel?.text = post.author?.username
        cell.captionLabel?.text = post.caption
        cell.timeLabel?.text = "2h ago" // We will fix the Date logic later
        
        // 2. Images (Using the helper extension we made)
        cell.postImageView?.configureImage(with: post.postImageString)
        
        // Safety check: author might be nil in some rare cases
        if let author = post.author {
            cell.avatarImageView?.configureImage(with: author.profileImageString)
        } else {
            cell.avatarImageView?.image = UIImage(systemName: "person.circle")
        }

        return cell
    }
}
