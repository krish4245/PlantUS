
//  SearchPeopleViewController.swift
//  garden_app
//
//  Created by SDC-USER on 28/11/25.


import UIKit

class SearchPeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data Variables
    var allUsers: [User] = []       // 1. Holds everyone from DataStore
    var filteredUsers: [User] = []  // 2. Holds search results
    var isSearching: Bool = false   // 3. Tracks if we are typing

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup UI
        setupSearchBar()
        setupTableView()
        setupKeyboardDismiss() // Added this function
        
        loadData()
    }
    
    func loadData() {
        CommunityDataStore.shared.fetchAllUsers { [weak self] users in
            guard let self = self else { return }
            self.allUsers = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Keyboard Dismiss Logic 
    func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // This ensures the tap doesn't block table view clicks
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Search Bar Setup
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self // Important: Connect Delegate
        
        let wrapperView = UIView()
        wrapperView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: 44)
        wrapperView.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
        ])
        
        navigationItem.titleView = wrapperView
    }
    
    // MARK: - Search Logic
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredUsers.removeAll()
        } else {
            isSearching = true
            filteredUsers = allUsers.filter { user in
                return user.name.lowercased().contains(searchText.lowercased()) ||
                       user.username.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - TableView Setup
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.keyboardDismissMode = .onDrag
        
        let nib = UINib(nibName: "PeopleTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Switch between lists based on search state
        return isSearching ? filteredUsers.count : allUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        // Pick the correct user
        let user: User
        if isSearching {
            user = filteredUsers[indexPath.row]
        } else {
            user = allUsers[indexPath.row]
        }
        
        // Configure Data
        cell.nameLabel.text = user.name
        cell.messageLabel.text = user.searchSubtitle
        
        if let imageView = cell.avatarImageView {
            imageView.image = UIImage(systemName: user.profileImageString)
        }
        
        cell.timeLabel.isHidden = true
        cell.accessoryType = .disclosureIndicator // Arrow to show it's clickable
        
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the user
        let selectedUser = isSearching ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        performSegue(withIdentifier: "ShowUserProfile", sender: selectedUser)
    }
    
    // Pass the user to the Profile Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserProfile",
           let profileVC = segue.destination as? ProfileViewController,
           let user = sender as? User {
            profileVC.user = user
        }
    }
}
