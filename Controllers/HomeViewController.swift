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
    
    
    @IBOutlet weak var statusCardView: UIView!   // the new one
    
    // Add missing stat card outlets (connect these in Interface Builder)
    @IBOutlet weak var totalPlantsCardView: UIView?
    @IBOutlet weak var spacesCardView: UIView?

    // Master list of plants
    private var plants: [Plant] = [
        // Ensure these names exactly match your Assets.xcassets image names
        Plant(name: "Monstera",   subtitle: "Water Today", imageName: "Monsters", careType: .watering),
        Plant(name: "Lil Sprout", subtitle: "Water Today", imageName: "lil_sprout", careType: .watering),
        Plant(name: "Sunny S.",   subtitle: "Water Today", imageName: "sunnys", careType: .watering),
        Plant(name: "Fern Friend", subtitle: "Water Today", imageName: "Monsters", careType: .trimming),
        Plant(name: "Cactus Buddy", subtitle: "Water Today", imageName: "indoor-plants-studio", careType: .trimming)
    ]

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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Intentionally left blank: tapping the profile button should do nothing for now.
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
