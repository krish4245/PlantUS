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
    //@IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    // MARK: - Data
    // We use the new Post model we created
    private var posts: [Post] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupTable()
        loadData()
        
        postsTableView.delaysContentTouches = false
            
            // 2. Ensure buttons get priority over scrolling
            for case let scrollView as UIScrollView in postsTableView.subviews {
                scrollView.delaysContentTouches = false
            }
        
        postsTableView.allowsSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: NSNotification.Name("NewPostAdded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        cell.configure(with: post)
    
        cell.onLikeTapped = { [weak self] (newIsLiked, newCount) in
            guard let self = self else { return }
            
            
            self.posts[indexPath.row].isLiked = newIsLiked
            self.posts[indexPath.row].likesCount = newCount
            
            
            CommunityDataStore.shared.updateLikeStatus(forPostId: post.id, isLiked: newIsLiked, newCount: newCount)
            // 3. Animation: Add a little bounce effect
            //self.animateLikeButton(cell.likeButton)
            //print("Like toggled for post: \(post.id). New State: \(newState)")
        }
        cell.onAvatarTapped = { [weak self] in if let author = post.author {
                        self?.performSegue(withIdentifier: "ShowUserProfile", sender: author)
                }
            }
                
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This checks if the screen we are opening is the NewPostViewController
        if let newPostVC = segue.destination as? NewPostViewController {
            
            // We pass a "Callback" function.
            // When NewPostViewController finishes uploading, it runs this code block.
            newPostVC.onPostSuccess = { [weak self] in
                // Reload the data instantly
                self?.loadData()
            }
        }
        if segue.identifier == "ShowUserProfile"{
            if let profileVC = segue.destination as? ProfileViewController {
                
                // The 'sender' is the User object we passed in Step 3
                if let selectedUser = sender as? User {
                    profileVC.user = selectedUser
                }
        
        
                // Optional: Scroll to the top so the user sees their new post
                //                    if let count = self?.posts.count, count > 0 {
                //                        self?.postsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                //                    }
            }
        }
    }
    
    
}
