//
//  ChatViewController.swift
//  garden_app
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

// 1. Simple Model for our Messages
struct Message {
    let text: String
    let isSender: Bool // true = Me (Green), false = Them (Gray)
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    // Top Header
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerNameLabel: UILabel!
    
    // The Chat Area
    @IBOutlet weak var tableView: UITableView!
    
    // The Bottom Input Area
    @IBOutlet weak var inputContainerView: UIView!      // The whole bottom bar
    @IBOutlet weak var messageTextField: UITextField!   // The text field
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint! // ⚠️ Connect this to the Bottom Constraint of the Input View!
    
    // MARK: - Data
    var user: User? // The person we are talking to
    
    // Dummy Data
    var messages: [Message] = [
        Message(text: "May I know about the plants you have? 🤗", isSender: true),
        Message(text: "Sureee I would love to tell lets meet at 7? 🤗", isSender: false),
        Message(text: "That sounds perfect! See you then.", isSender: true)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            print("✅ Step 4: Chat Screen received user: \(user.name)")
        } else {
            print("❌ Error: Chat Screen user is NIL!")
        }
        setupUI()
        setupKeyboardObservers()
        
        messageTextField.delegate = self
    }
    
    // MARK: - Setup & Styling 🎨
    func setupUI() {
        // 1. Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // Remove lines
        tableView.allowsSelection = false // Disable clicking cells
        
        // 2. Setup Header Data (If user is passed)
        if let user = user {
            headerNameLabel.text = user.name
            headerImageView.configureImage(with: user.profileImageString)
        }
        
        // 3. Styling (Corner Radius in Code as requested)
        // Make Avatar Circular
        headerImageView.layer.cornerRadius = headerImageView.frame.height / 2
        headerImageView.clipsToBounds = true
        
        // Make the Text Field "Pill" shape (Assuming height is ~36-40)
        // Note: You might need an outlet for the white pill container if you made one,
        // otherwise we just style the text field background if that's what you used.
        messageTextField.superview?.layer.cornerRadius = 18
        messageTextField.superview?.clipsToBounds = true
    }
    
    // MARK: - TableView Logic 📝
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        // 1. Decide which cell to load
        let cellIdentifier = message.isSender ? "SenderCell" : "ReceiverCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatBubbleCell
        
        // 2. Set Text
        cell.messageLabel.text = message.text
        
        // 3. Apply Corner Radius Code (As requested!) 🟢⚪️
        cell.bubbleView.layer.cornerRadius = 16
        // Optional: specific corners if you want the "Tail" look
        if message.isSender {
            cell.bubbleView.backgroundColor = UIColor.systemGreen
            cell.messageLabel.textColor = .white
            // Round top-left, top-right, bottom-left (Leave bottom-right sharp?)
            cell.bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        } else {
            cell.bubbleView.backgroundColor = UIColor.systemGray5
            cell.messageLabel.textColor = .black
            // Round top-left, top-right, bottom-right (Leave bottom-left sharp?)
            cell.bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        
        return cell
    }
    
    // MARK: - Keyboard Handling ⌨️
    // This moves the input bar up when keyboard opens
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Move up by keyboard height - safe area
            // Note: We use negative value because bottom constraints pull up when negative
            if let constraint = inputBottomConstraint {
                constraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            scrollToBottom()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Move back to zero
        if let constraint = inputBottomConstraint {
            constraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollToBottom() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Sending Logic 🚀

        // This function runs when the user hits "Return" or "Send" on the keyboard
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            sendMessage()
            return true
        }

        func sendMessage() {
            // 1. Check if text exists and isn't just spaces
            guard let text = messageTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }

            // 2. Create the new message object (Me = isSender: true)
            let newMessage = Message(text: text, isSender: true)

            // 3. Add to our data source
            messages.append(newMessage)

            // 4. Insert the row into the TableView nicely (Animation)
            let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .right)
            
            // 5. Scroll to the new message
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)

            // 6. Clear the text field
            messageTextField.text = ""
        }
    
    
}
