//
//  commentViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 27/11/25.
//

//import UIKit
//
//class CommentsViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    // Match the feed's model type
//    var post: Post?
//
//    // Dummy comments for now
//    var comments: [String] = [
//        "Love this plant! 🌿",
//        "Looks amazing 😍",
//        "Wow, where did you get this?",
//        "Such a vibe!"
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        view.backgroundColor = .systemBackground
//    }
//}
//
//extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
//
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")
//            ?? UITableViewCell(style: .default, reuseIdentifier: "CommentCell")
//
//        cell.textLabel?.text = comments[indexPath.row]
//        cell.selectionStyle = .none
//        return cell
//    }
//}
