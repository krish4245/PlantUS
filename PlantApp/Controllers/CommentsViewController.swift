//
//  CommentsViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 20/01/26.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    // Connect this to the constraint at the bottom of the screen (Value = 0)
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Data
    var post: Post! // We receive the post data here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
        if post == nil {
                print("❌ ERROR: No Post data was passed to Comments Screen!")
                // Optional: Dismiss the screen automatically
                // self.dismiss(animated: true)
                return
            }
        
        // Setup Table
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup Keyboard
        commentTextField.delegate = self
        setupKeyboardObservers()
        
        // Hide extra empty lines in table
        tableView.tableFooterView = UIView()
    }

    // MARK: - TableView Logic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
        let comment = post.comments[indexPath.row]
        
        cell.usernameLabel.text = comment.username
        cell.timeLabel.text = comment.timeAgo
        cell.commentLabel.text = comment.text
        
        return cell
    }
    
    // MARK: - Actions
    
    // Connect this to the "X" button at the top
    @IBAction func closeTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Connect this to the "Post" button
    @IBAction func postTapped(_ sender: UIButton) {
        sendComment()
    }
    
    // Handle "Return" key on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return true
    }
    
    func sendComment() {
        guard let text = commentTextField.text, !text.isEmpty else { return }
        
        // 1. Create Data
        let newComment = Comment(
            id: UUID(),
            username: "Shubham_r24", // Placeholder name
            text: text,
            timeAgo: "Just now"
        )
        
        // 2. Add to list
        post.comments.append(newComment)
        
        // 3. Update Table
        tableView.reloadData()
        
        // 4. Scroll to bottom
        if post.comments.count > 0 {
            let indexPath = IndexPath(row: post.comments.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        // 5. Clear Input
        commentTextField.text = ""
    }
    
    // MARK: - Keyboard Handling (The Slide Up Fix)
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Tap background to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Move up
            let height = -(keyboardSize.height - view.safeAreaInsets.bottom)
            inputBottomConstraint.constant = height
            UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Move down
        inputBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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


