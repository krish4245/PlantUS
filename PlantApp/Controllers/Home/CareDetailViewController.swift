//
//  CareDetailViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 13/01/26.
//

import UIKit

final class CareDetailViewController: UIViewController {
   

    @IBOutlet weak var tableView: UITableView!

    var pageTitle: String = ""
    var careKind: CareType = .watering

    private var plantsToShow: [PlantModel_Ved] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = pageTitle
        navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 70
        loadPlants()
    }

    private func loadPlants() {

        let allPlants = PlantDataSource.shared.plants

        //  Filtering based on careKind
        plantsToShow = allPlants.filter { $0.careTasks.contains(careKind) }


        tableView.reloadData()
    }
}

extension CareDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = plantsToShow[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCareCell", for: indexPath)
        cell.textLabel?.text = plant.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell.detailTextLabel?.textColor = .secondaryLabel
        let doneButton = UIButton(type: .system)
           doneButton.setTitle("Done", for: .normal)
           doneButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
           doneButton.setTitleColor(.systemGreen, for: .normal)
           doneButton.layer.cornerRadius = 12
           doneButton.frame = CGRect(x: 0, y: 0, width: 90, height: 32)

           doneButton.tag = indexPath.row
           doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)

           //  put button on right side
           cell.accessoryView = doneButton
        switch careKind {
            case .watering:
                cell.detailTextLabel?.text = "Water today"
            case .repotting:
                cell.detailTextLabel?.text = "Repot today"
            case .fertilizing:
                cell.detailTextLabel?.text = "Fertilize today"
            case .trimming:
                cell.detailTextLabel?.text = "Prune today"
            }
        
        
        cell.selectionStyle = .none
        return cell
    }
    @objc private func doneButtonTapped(_ sender: UIButton) {

        //  find the cell that contains this button
        guard let cell = sender.superview as? UIView else { return }

        var view: UIView? = sender
        while view != nil && !(view is UITableViewCell) {
            view = view?.superview
        }

        guard
            let tableCell = view as? UITableViewCell,
            let indexPath = tableView.indexPath(for: tableCell)
        else { return }

        //  Update your array first
        plantsToShow.remove(at: indexPath.row)

        //  Animate fade delete
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .fade)
        }, completion: nil)
    }


}
