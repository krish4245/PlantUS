import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: - Search & Data
    // We create the controller in code to get the native animation
    let searchController = UISearchController(searchResultsController: nil)
    
    var allFriends: [User] = []
    var filteredFriends: [User] = []
    
    // Computed property: Are we currently searching?
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup TableView
        setupTableView()
        
        // 2. Setup Native Search (The Animation)
        setupSearchController()
        
        // 3. Load Data
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the search bar doesn't disappear when coming back
        navigationItem.hidesSearchBarWhenScrolling = false
        loadData()
    }
    
    func loadData() {
        CommunityDataStore.shared.fetchAllUsers { [weak self] users in
            guard let self = self else { return }
            self.allFriends = users.filter { $0.isFriend == true }
            self.tableView.reloadData()
        }
    }

    // MARK: - Setup Functions
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // 👇 FIX FOR "EATEN UP" CELLS
        // Since you are using a XIB, sometimes auto-sizing fails.
        // Force a height to ensure they look correct.
        tableView.rowHeight = 80
        
        // Register the XIB (Crucial since you deleted the Storyboard prototype)
        let nib = UINib(nibName: "PeopleTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
        
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView() // Removes empty lines at bottom
    }
    
    func setupSearchController() {
        // This connects the search logic
        searchController.searchResultsUpdater = self
        
        // Design settings
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search friends..."
        
        // Add it to the Navigation Bar (This gives the animation!)
        navigationItem.searchController = searchController
        
        // Ensure it is always visible
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // MARK: - Search Logic
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = allFriends.filter { (user: User) -> Bool in
            return user.name.lowercased().contains(searchText.lowercased()) ||
                   user.username.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredFriends.count : allFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // This uses your XIB file
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let user = isSearching ? filteredFriends[indexPath.row] : allFriends[indexPath.row]
        
        cell.nameLabel.text = user.name
        cell.messageLabel.text = "Hey! How are your plants? 🌱"
        cell.timeLabel.text = "9:41 AM"
        cell.avatarImageView.configureImage(with: user.profileImageString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = isSearching ? filteredFriends[indexPath.row] : allFriends[indexPath.row]
        print("Selected: \(user.name)")
        
        // performSegue(withIdentifier: "OpenChat", sender: user)
    }
}
