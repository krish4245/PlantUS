//
//  SearchPeopleViewController.swift
//  garden_app
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class SearchPeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // Hardcoded data for this screen
    let results = [
        ("Shubham_r24", "12 plants | 5 friends", "person.circle.fill"),
        ("Krishna_upp", "32 plants | 52 friends", "person.crop.circle"),
        ("Vedant_arya", "22 plants | 9 friends", "person.circle"),
        ("Virat_kohli", "30 plants | 100 friends", "person.fill")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup Search Bar in Navigation (This is best done in code to keep the Back button working)
        setupSearchBar()
        
        // 2. Setup TableView
        setupTableView()
        
        // 3. Style the Segmented Control (Optional - makes it look cleaner)
        //segmentedControl.selectedSegmentIndex = 0
    }

    // MARK: - 1. The Search Bar Header
    // Renamed to match call site
    func setupSearchBar() {
            // 1. Create the Search Bar
            let searchBar = UISearchBar()
            searchBar.placeholder = "Plants"
            searchBar.searchBarStyle = .minimal // This gives the gray "pill" look
            
            // 2. Create a "Wrapper" View
            // We give it a flexible width so it fits between the Back Button and the Right edge
            let wrapperView = UIView()
            wrapperView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: 44)
            
            // 3. Add Search Bar to Wrapper
            wrapperView.addSubview(searchBar)
            
            // 4. Use Auto Layout to pin the Search Bar to the Wrapper
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBar.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
                searchBar.topAnchor.constraint(equalTo: wrapperView.topAnchor),
                searchBar.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
            ])
            
            // 5. Set the Wrapper as the Title View
            navigationItem.titleView = wrapperView
        }
    // MARK: - 2. TableView setup
    func setupTableView() {
        // If tableView is from storyboard, it already exists. Just wire it up.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        // Register the XIB for PeopleTableViewCell so dequeue works
        let nib = UINib(nibName: "PeopleTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let data = results[indexPath.row]
        
        // Configure Data
        cell.nameLabel.text = data.0
        cell.messageLabel.text = data.1
        cell.avatarImageView.image = UIImage(systemName: data.2)
        
        // Hide elements not needed for this screen
        cell.timeLabel.isHidden = true
        // cell.statusDot.isHidden = true
        cell.accessoryType = .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
