//
//  ViewController.swift
//  Sample_searchPage
//
//  Created by vedant on 31/12/25.
//

import UIKit

class SearchPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UISearchResultsUpdating {
   

    @IBOutlet weak var collectionView: UICollectionView!
    
    let plantDataSource = PlantDataSource.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredBrowsePlants: [PlantModel_Ved] = []
    var browsePlants: [PlantModel_Ved] = []
    var isSearching = false

    
    enum SearchSection : Int,CaseIterable {
        case recommended
        case browseAll
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        browsePlants = PlantDataSource.shared.allPlants
        filteredBrowsePlants = browsePlants
        
        setupSearchController()
       
        
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        setupMoreButton()
        
        registerCells()
    }
    
    private func setupMoreButton() {
        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(moreTapped)
        )
        navigationItem.rightBarButtonItem = moreButton
    }
    func setupSearchController() {
        // 1. connect delegate
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Categories"

        // 2. Add to Navigation Item (This puts it in the large title area like Apple Health)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        // 3. Prevent the search bar from hiding the Tab Bar
        definesPresentationContext = true
    }
    @objc func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    @objc private func moreTapped() {
        let actionSheet = UIAlertController(
           
        )

        let scanAction = UIAlertAction(title: "Scan Plant", style: .default) { _ in
            self.openCamera()
        }

        let galleryAction = UIAlertAction(title: "Upload from Gallery", style: .default) { _ in
            self.openGallery()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        actionSheet.addAction(scanAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)

        // iPad safety
        if let popover = actionSheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(actionSheet, animated: true)
    }
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    private func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        //  dismiss FIRST, then navigate
        picker.dismiss(animated: true) {
            self.goToScanResult(image: image)
        }
    }
    
    private func goToScanResult(image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(
            withIdentifier: "ScanResult"
        ) as! ScanResult

        vc.capturedImage = image
        vc.plantName = "Unknown Plant" // temporary

        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    
    
    func filterContentForSearchText(_ searchText: String) {
        let lowerText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if lowerText.isEmpty {
            isSearching = false
            filteredBrowsePlants = browsePlants
        } else {
            isSearching = true
            filteredBrowsePlants = browsePlants.filter { plant in
                plant.name.lowercased().contains(lowerText)
            }
        }
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false) // ✅
        collectionView.reloadData()
    }


    
    
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section : Int)-> Int {
        
        
      
        
        let sectionType = SearchSection(rawValue: section)!

           switch sectionType {

           case .recommended:
               //  Hide recommended while searching
               return isSearching ? 0 : plantDataSource.recommendedPlants.count

           case .browseAll:
               // ✅ Always show browse - filtered or full
               return filteredBrowsePlants.count
           }
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

           let plant = filteredBrowsePlants[indexPath.item]
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
        
        // ✅ If searching: show header ONLY for browseAll section
           if isSearching {
               if sectionType == .recommended {
                   header.titleLabel.text = ""
                   header.isHidden = true
                   return header
               } else {
                   header.titleLabel.text = "Browse Plants"
                   header.isHidden = false
                   return header
               }
           }
        
        // ✅ Normal (not searching)
          header.isHidden = false
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
            
            if self.isSearching {
                       return self.browseAllSectionLayout()
                   }

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
            heightDimension: isSearching ? .absolute(0) : .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(170),
            heightDimension: .absolute(210)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        section.interGroupSpacing = 12   //  ADD THIS
           section.contentInsets = NSDirectionalEdgeInsets(
               top: 8,
               leading: 16,
               bottom: 24,
               trailing: 16
           )
        
        
        
        section.boundarySupplementaryItems = isSearching ? [] : [header]

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
        
        
        section.interGroupSpacing = 12  
           section.contentInsets = NSDirectionalEdgeInsets(
               top: 8,
               leading: 16,
               bottom: 16,
               trailing: 16
           )
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        
        
        if isSearching {
              let plant = filteredBrowsePlants[indexPath.item]
              navigateToPlantDetail(with: plant)
              return
          }

        let sectionType = SearchSection(rawValue: indexPath.section)!

        let plant: PlantModel_Ved

        switch sectionType {
        case .recommended:
            plant = PlantDataSource.shared.recommendedPlants[indexPath.item]
        case .browseAll:
            plant = filteredBrowsePlants[indexPath.item]
        }

        navigateToPlantDetail(with: plant)
    }
    
    private func navigateToPlantDetail(with plant: PlantModel_Ved) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(
            withIdentifier: "PlantDetailViewController"
        ) as! PlantDetailViewController

        vc.plantId = plant.id   //  Passing ID
        navigationController?.pushViewController(vc, animated: true)
    }

    
    

    
  



}

