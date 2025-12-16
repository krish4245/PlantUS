//
//  ViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var careTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var emptyStateView: UIView!

    @IBOutlet weak var statusCardView: UIView!   // the new one
    
    // Add missing stat card outlets (connect these in Interface Builder)
    @IBOutlet weak var totalPlantsCardView: UIView?
    @IBOutlet weak var spacesCardView: UIView?


    
//    @IBAction func plantTapped(_ sender: UIButton) {
//        selectedPlant = plants[sender.tag]
//        performSegue(withIdentifier: "showPlantCareModal", sender: self)
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlant = plants[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "PlantCareModalViewController"
        ) as! PlantCareModalViewController

        vc.plant = selectedPlant
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlantCareModal" {
            let vc = segue.destination as! PlantCareModalViewController
            vc.plant = selectedPlant
        }
    }

    
    private func updateHomeUI() {
        let hasPlants = !plants.isEmpty

        plantsCollectionView.isHidden = !hasPlants
        emptyStateView.isHidden = hasPlants
    }

    
    
    // Master list of plants
    private var plants: [Plant] = [
        // Ensure these names exactly match your Assets.xcassets image names
        Plant(name: "Monstera",   subtitle: "Water Today", imageName: "Monsters", careType: .watering,
             wateringDone: false,
             sunlightDone: false,
             fertilizingDone: false),
        Plant(name: "Lil Sprout", subtitle: "Water Today", imageName: "lil_sprout", careType: .watering,
              wateringDone: false,
              sunlightDone: false,
              fertilizingDone: false),
        Plant(name: "Sunny S.",   subtitle: "Water Today", imageName: "sunnys", careType: .watering,
              wateringDone: false,
              sunlightDone: false,
              fertilizingDone: false),
        Plant(name: "Fern Friend", subtitle: "Water Today", imageName: "Monsters", careType: .trimming,
              wateringDone: false,
              sunlightDone: false,
              fertilizingDone: false),
        Plant(name: "Cactus Buddy", subtitle: "Water Today", imageName: "indoor-plants-studio", careType: .trimming,
              wateringDone: false,
              sunlightDone: false,
              fertilizingDone: false)
    ]
    var selectedPlant:   Plant?
    // Currently visible (filtered) plants
    private var visiblePlants: [Plant] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func didTapPlant(at index: Int) {
        selectedPlant = plants[index]
        performSegue(withIdentifier: "showPlantCareModal", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHomeUI()

        NotificationCenter.default.addObserver(
              self,
              selector: #selector(handlePlantCareCompleted),
              name: .plantCareCompleted,
              object: nil
          )
        
        
        styleCards()
        let cards: [UIView?] = [card1, card2]
        cards.forEach { card in
            card?.layer.cornerRadius = 16
            card?.layer.masksToBounds = true
        }
 
        view.backgroundColor = .systemBackground
        plantsCollectionView.dataSource = self
        plantsCollectionView.delegate = self

        // Default to "Watering" segment and filter accordingly
        careTypeSegmentedControl.selectedSegmentIndex = 0
        visiblePlants = plants.filter { $0.careType == .watering }

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        navigationItem.titleView = container

        container.setContentHuggingPriority(.required, for: .horizontal)
        container.setContentCompressionResistancePriority(.required, for: .horizontal)

        let profileImage = UIImage(systemName: "person.circle.fill")
        let profileButton = UIBarButtonItem(image: profileImage,
                                            style: .plain,
                                            target: self,
                                            action: #selector(profileTapped))
        navigationItem.rightBarButtonItem = profileButton
        
        
        

        if let layout = plantsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 12
        }
        plantsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func handlePlantCareCompleted(notification: Notification) {
        guard let plantID = notification.object as? String else { return }

        // Remove from master list
        plants.removeAll { $0.id == plantID }

        // Recompute visible list based on current segment
        visiblePlants = plantsForSelectedSegment()

        // Reload the collection view
        plantsCollectionView.reloadData()
    }

    
    private func plantsForSelectedSegment() -> [Plant] {
        guard let type = CareType(rawValue: careTypeSegmentedControl.selectedSegmentIndex) else {
            return plants
        }
        return plants.filter { $0.careType == type }
    }
    
    
    private func styleCards() {
        // Light green for the stat cards
        let statCards = [totalPlantsCardView, spacesCardView]
        statCards.forEach { card in
            guard let card = card else { return }
            card.layer.cornerRadius = 18
            card.layer.masksToBounds = true
            card.backgroundColor = UIColor(
                red: 0.90, green: 0.97, blue: 0.90, alpha: 1.0
            ) // soft green
        }
        
        // White, elevated card for Garden Status
        statusCardView.layer.cornerRadius = 18
        statusCardView.layer.masksToBounds = false
        statusCardView.backgroundColor = .systemBackground
        
        statusCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        statusCardView.layer.shadowOpacity = 1
        statusCardView.layer.shadowRadius = 10
        statusCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    // Make the profile button a no-op
    @objc private func profileTapped() {
        // instantiate from same storyboard; fails silently if not found
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "userProfileViewController") {
            profileVC.modalPresentationStyle = .pageSheet
            present(profileVC, animated: true)
        } else {
            print("ProfileViewController not found — check Storyboard ID and Module")
        }
    }


    @IBAction func careTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Watering
            visiblePlants = plants.filter { $0.careType == .watering }
        case 1: // Trimming
            visiblePlants = plants.filter { $0.careType == .trimming }
        default:
            visiblePlants = plants
        }

        plantsCollectionView.setContentOffset(.zero, animated: false)
        plantsCollectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return visiblePlants.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PlantCell",
            for: indexPath
        ) as? PlantCollectionViewCell else {
            return UICollectionViewCell()
        }

        let plant = visiblePlants[indexPath.item]
        cell.configure(with: plant)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 170)
    }
}
//test

