import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 1. UI Elements
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
    // 2. Data
    // I added a simple struct here so we can hold more data than just names
    struct Contact {
        let name: String
        let image: String // System image name for now
        let isOnline: Bool
    }
    
    let contacts = [
        Contact(name: "Vedant", image: "person.crop.circle", isOnline: true),
        Contact(name: "Krishna", image: "person.crop.circle.fill", isOnline: true),
        Contact(name: "Simran", image: "person.circle", isOnline: false),
        Contact(name: "Shubham", image: "person.fill", isOnline: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTableView()
    }

    // MARK: - Setup Functions
    func setupNavBar() {
        self.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let addIcon = UIImage(systemName: "person.badge.plus")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addIcon, style: .plain, target: self, action: nil)
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        // Register PeopleTableViewCell. If using a XIB, register the nib instead.
        // If you have a xib named "PeopleTableViewCell.xib", uncomment the nib registration and remove class registration.
        let nib = UINib(nibName: "PeopleTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
        //tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: "PeopleTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80 // Height to match your design
        tableView.tableFooterView = UIView() // Removes empty lines at bottom
    }

    // MARK: - TableView Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom PeopleTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let contact = contacts[indexPath.row]
        
        // Configure the cell with data
        cell.nameLabel.text = contact.name
        cell.messageLabel.text = "Message preview" // Static for now
        cell.timeLabel.text = "9:41 AM"
        
        // Set the image (Using system symbols for now so it doesn't crash)
        cell.avatarImageView.image = UIImage(systemName: contact.image)
        
        // If you later add a statusDot outlet, you can show/hide it here.
        // cell.statusDot.isHidden = !contact.isOnline
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped on \(contacts[indexPath.row].name)")
    }
}
