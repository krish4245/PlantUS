//
//  SearchSuggestionsViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 09/12/25.
//


import UIKit

// Small results controller used by UISearchController to show suggestions
final class SearchSuggestionsViewController: UITableViewController {
    var suggestions: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var didSelectSuggestion: ((String) -> Void)?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        tableView.tableFooterView = UIView()
    }
    

    // MARK: - Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        c.textLabel?.text = suggestions[indexPath.row]
        c.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return c
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectSuggestion?(suggestions[indexPath.row])
    }
}
