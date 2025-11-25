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
 
    private var plants: [Plant] = [
        // Ensure these names exactly match your Assets.xcassets image names
        Plant(name: "Monstera",   subtitle: "Water Today", imageName: "monstera"), // <- fix from "Monsters"
        Plant(name: "Lil Sprout", subtitle: "Water Today", imageName: "lil_sprout"),
        Plant(name: "Sunny S.",   subtitle: "Water Today", imageName: "sunny"),
        Plant(name: "Fern Friend", subtitle: "Water Today", imageName: "fern"),
        Plant(name: "Cactus Buddy", subtitle: "Water Today", imageName: "cactus")
    ]

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
        
        let cards: [UIView?] = [card1, card2]
        cards.forEach { card in
            card?.layer.cornerRadius = 16   // try 16, adjust to taste
            card?.layer.masksToBounds = true
        }
        
        view.backgroundColor = .systemBackground
        plantsCollectionView.dataSource = self
        plantsCollectionView.delegate = self
        
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

    @objc private func profileTapped() {
        let alert = UIAlertController(title: "Profile", message: "Profile button tapped.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func careTypeChanged(_ sender: UISegmentedControl) {
        // later we'll filter by Watering / Trimming / Repot
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        plants.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PlantCell",
            for: indexPath
        ) as? PlantCollectionViewCell else {
            return UICollectionViewCell()
        }

        let plant = plants[indexPath.item]
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
