//
//  SearchViewController.swift
//  garden_app
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

// Added UICollectionViewDataSource and UICollectionViewDelegate
class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Outlets
    // Don't forget to connect this in Storyboard!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // 1. Setup Collection View
            collectionView.dataSource = self
            collectionView.delegate = self
            
            // 2. Assign the layout
            collectionView.collectionViewLayout = createLayout()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Keep the nav bar hidden so we can use our custom header
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        // MARK: - Layout Logic
        func createLayout() -> UICollectionViewLayout {
            return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                
                if sectionIndex == 0 {
                    // MARK: SECTION 0 - RECOMMENDED (Horizontal)
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 0, trailing: 2)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(200))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
                    
                    // --- FIXED: ADDED HEADER BACK ---
                    // This tells the app to reserve space for the Search Bar
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                    
                    section.boundarySupplementaryItems = [header]
                    // --------------------------------
                    
                    return section
                    
                } else if sectionIndex == 1 {
                    // MARK: SECTION 1 - TITLE CELL ("Browse all plants")
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 15, trailing: 0)
                    
                    return section
                    
                } else {
                    // MARK: SECTION 2 - BROWSE LIST (Vertical)
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
                    
                    return section
                }
            }
        }

        // MARK: - Data Source
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 3 // 0=Recommended, 1=Title, 2=Browse
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if section == 0 { return PlantData.recommended.count }
            if section == 1 { return 1 }
            return PlantData.browse.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if indexPath.section == 0 {
                // SECTION 0: RECOMMENDED
                // Ensure this class name matches your Swift file
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! SearchCollectionViewCell
                
                // Get Data
                let plant = PlantData.recommended[indexPath.row]
                
                // Set Data (Make sure you connected these Outlets!)
                cell.nameLabel.text = plant.name
                cell.taglineLabel.text = plant.tagline
        
                cell.plantImageView.image = UIImage(named: plant.imageName)
                // cell.plantImageView.image = UIImage(named: plant.imageName)
                
                cell.layer.cornerRadius = 12
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.systemGray5.cgColor
                
                return cell
                
            } else if indexPath.section == 1 {
                // SECTION 1: TITLE
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath)
                return cell
                
            } else {
                // SECTION 2: BROWSE
                // Ensure this class name matches your Swift file (including typo if it exists)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseCell", for: indexPath) as! Search_2CollectionViewCell
                
                // Get Data
                let plant = PlantData.browse[indexPath.row]
                
                // Set Data
                cell.nameLabel.text = plant.name
                cell.plantImageView.image = UIImage(named: plant.imageName)
                        
                        // NEW: Set the detailed info
                cell.maintenanceLabel.text = plant.maintenance
                cell.lightLabel.text = plant.light
                cell.waterLabel.text = plant.water
                        
                        // Quick trick to show leaf icons without complex logic:
                        // You can add emojis to the text string directly if you don't want to manage image views
                        // e.g. cell.maintenanceLabel.text = "🍃🍃 " + plant.maintenance
                        
                cell.layer.cornerRadius = 20
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.systemGray5.cgColor
                // cell.plantImageView.image = UIImage(named: plant.imageName)
                
                return cell
            }
        }
        
        // MARK: - Header View Connection
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            // This puts the Search Bar Header ONLY on Section 0
            if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderView", for: indexPath)
                return headerView
            }
            
            return UICollectionReusableView()
        }
    }
