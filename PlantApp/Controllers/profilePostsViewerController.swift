//
//  profilePostsViewerController.swift
//  PlantApp
//
//  Created by SDC-USER on 14/01/26.
//

import UIKit

class profilePostsViewerController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    // The single post we want to show
    var post: Post?
    
    // We create a temporary list containing just that ONE post
    var tableData: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup the dummy data array
        if let post = post {
            tableData = [post] // The list has 1 item
        }
        
        // 2. Setup Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // Remove empty lines at the bottom
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count // This will be 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // We reuse the EXACT same cell design you already built!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        
        let currentPost = tableData[indexPath.row]
        
        // Reuse your existing configure function
        cell.configure(with: currentPost)
        
        // Handle the Like Button inside the detail view
        cell.onLikeTapped = { [weak self] (newIsLiked, newCount) in
            guard let self = self else { return }
            
            // Update the source of truth
            self.post?.isLiked = newIsLiked
            self.post?.likesCount = newCount
            self.tableData[0] = self.post! // Update the local list
            
            // Update Database
            CommunityDataStore.shared.updateLikeStatus(forPostId: currentPost.id, isLiked: newIsLiked, newCount: newCount)
        }
        
        return cell
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
