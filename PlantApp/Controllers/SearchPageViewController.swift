//
//  ViewController.swift
//  Sample_searchPage
//
//  Created by vedant on 31/12/25.
//

import UIKit

class SearchPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    let plantDataSource = PlantDataSource.shared

    

    
    enum SearchSection : Int,CaseIterable {
        case recommended
        case browseAll
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        
        
        registerCells()
    }
    
    func registerCells(){
        
        collectionView.register(
            UINib(nibName: "SearchSectionHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "SearchSectionHeaderView"
        )
        
        
        collectionView.register(UINib(nibName: "RecommendedPlantCell", bundle: nil), forCellWithReuseIdentifier: RecommendedPlantCell.identifier)
        
        collectionView.register(UINib(nibName: "BrowseAllPlantCell", bundle: nil), forCellWithReuseIdentifier: BrowseAllPlantCell.identifier)
        
        
    }
    

    
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SearchSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section : Int)-> Int {
        let sectionType = SearchSection(rawValue: section)!

           return sectionType == .recommended
               ? PlantDataSource.shared.recommendedPlants.count
               : PlantDataSource.shared.allPlants.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = SearchSection(rawValue : indexPath.section)!
       print("Section:", indexPath.section, "Item:", indexPath.item)

        
       switch sectionType {
       case .recommended:
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPlantCell.identifier, for: indexPath) as! RecommendedPlantCell
        
           let plant = plantDataSource.recommendedPlants[indexPath.item]
                   cell.configure(with: plant)
           return cell
           
           
           
       case .browseAll:
           let cell = collectionView.dequeueReusableCell(
               withReuseIdentifier: BrowseAllPlantCell.identifier,
               for: indexPath
           ) as! BrowseAllPlantCell

           let plant = plantDataSource.allPlants[indexPath.item]
                   cell.configure(with: plant)


           return cell
       }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SearchSectionHeaderView",
            for: indexPath
        ) as! SearchSectionHeaderView

        let sectionType = SearchSection(rawValue: indexPath.section)!

        switch sectionType {
        case .recommended:
            header.titleLabel.text = "Recommended Plants"
        case .browseAll:
            header.titleLabel.text = "Browse Plants"
        }

        return header
    }

    
    func createLayout() -> UICollectionViewLayout {

        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let sectionType = SearchSection(rawValue: sectionIndex)!

            switch sectionType {
            case .recommended:
                return self.recommendedSectionLayout()
            case .browseAll:
                return self.browseAllSectionLayout()
            }
        }
    }
    
    func recommendedSectionLayout() -> NSCollectionLayoutSection {
        
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(180),
            heightDimension: .absolute(220)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    func browseAllSectionLayout() -> NSCollectionLayoutSection {
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(140)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(140)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

       let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let sectionType = SearchSection(rawValue: indexPath.section)!

        let plant: PlantModel_Ved

        switch sectionType {
        case .recommended:
            plant = PlantDataSource.shared.recommendedPlants[indexPath.item]
        case .browseAll:
            plant = PlantDataSource.shared.allPlants[indexPath.item]
        }

        navigateToPlantDetail(with: plant)
    }
    
    private func navigateToPlantDetail(with plant: PlantModel_Ved) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(
            withIdentifier: "PlantDetailViewController"
        ) as! PlantDetailViewController

        vc.plantId = plant.id   // 🔑 PASSING ID
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let header = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: SearchSectionHeaderView.identifier,
//            for: indexPath
//        ) as! SearchSectionHeaderView
//
//        header.titleLabel.text =
//            indexPath.section == 0 ? "Recommended for you" : "Browse all plants"
//
//        return header
//    }
    
  



}

