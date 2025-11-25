//
//  CommunityViewController.swift
//  garden_app
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

//class CommunityViewController: UIViewController {

//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var messagesButton: UIButton!
//    @IBOutlet weak var addPostButton: UIButton!
//    @IBOutlet weak var searchButton: UIButton!
//    
//    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()

        // Do any additional setup after loading the view.
    //}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}


import UIKit

class CommunityViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!

    @IBOutlet weak var postsTableView: UITableView!

    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        loadDummyData()
    }

    private func setupTable() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.separatorStyle = .none
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 400
    }

    private func loadDummyData() {
        let vedant = User(name: "Vedant_Arya", avatarImageName: nil)
        let plantParent = User(name: "Plantparentpro", avatarImageName: nil)

        posts = [
            Post(user: vedant,
                 imageName: "plant_1",
                 caption: "New leaf alert! 🌿",
                 timeAgo: "2h"),
            Post(user: plantParent,
                 imageName: "plant_2",
                 caption: "Watered and happy again 💧",
                 timeAgo: "5h")
        ]

        postsTableView.reloadData()
    }
}

extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

