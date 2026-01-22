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
    
    //a temporary list containing just that selected post
    var tableData: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the dummy data array
        if let post = post {
            tableData = [post] // The list has 1 item
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //used same tableview frim community posts
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        
        let currentPost = tableData[indexPath.row]
        
        //reused same config func from postsTableView
        cell.configure(with: currentPost)
        cell.onLikeTapped = { [weak self] (newIsLiked, newCount) in
            guard let self = self else { return }
            
            //updating main datastore
            self.post?.isLiked = newIsLiked
            self.post?.likesCount = newCount
            self.tableData[0] = self.post! //updating local list
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
