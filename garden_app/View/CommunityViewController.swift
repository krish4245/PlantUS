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
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = "\(post.user.name)\n\(post.caption)"
        cell.configure(with: post)

        return cell
    }

        
        // Do any additional setup after loading the view.

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
