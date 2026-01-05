////
////  SearchViewController.swift
////  garden_app
////
//
//import UIKit
//
//class SearchViewController: UIViewController,
//                            UICollectionViewDataSource,
//                            UICollectionViewDelegate,
//                            UIImagePickerControllerDelegate,
//                            UINavigationControllerDelegate,
//                            SearchHeaderViewDelegate {
//    func searchHeaderDidTapMenu(_ header: SearchHeaderView) {
//        // Present the scan/upload menu anchored to the header's menu button if available.
//        presentMenuOptions(sourceView: header.menuButton)
//    }
//
//    // MARK: - IBOutlets
//    @IBOutlet weak var collectionView: UICollectionView?
//
//    // MARK: - State
//    private var recentPredictions: [String] = []
//    private let smoothingWindow = 5
//
//    private var searchController: UISearchController!
//    private let suggestionsVC = SearchSuggestionsViewController()
//
//    // Minimal helper to avoid crashes if something is unexpectedly nil
//    private func safePrint(_ msg: String) {
//        print(" SearchVC:", msg)
//    }
//
//    private func addPrediction(_ label: String) -> String {
//        recentPredictions.append(label)
//        if recentPredictions.count > smoothingWindow { recentPredictions.removeFirst() }
//
//        let counts = Dictionary(grouping: recentPredictions, by: { $0 })
//            .mapValues { $0.count }
//        return counts.max(by: { $0.value < $1.value })?.key ?? label
//    }
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        collectionView?.keyboardDismissMode = .onDrag
//        guard let cv = collectionView else {
//            safePrint(" collectionView outlet is NOT connected (collectionView == nil). Connect it in Interface Builder.")
//            return
//        }
//
//        // Set delegates
//        cv.dataSource = self
//        cv.delegate = self
//        cv.collectionViewLayout = createLayout()
//
//        //selection possible
//        cv.allowsSelection = true
//        cv.isUserInteractionEnabled = true
//
//        configureSearchController()
//
//        // small debug snapshot
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            self.safePrint("collectionView frame: \(cv.frame)")
//            self.safePrint("delegate === self? \(cv.delegate === self)")
//            self.safePrint("dataSource === self? \(cv.dataSource === self)") // only to check
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//
//    // MARK: - Layout
//    func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { sectionIndex, _ in
//            if sectionIndex == 0 {
//                let item = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1.0),
//                        heightDimension: .fractionalHeight(1.0)
//                    )
//                )
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 0, trailing: 2)
//
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(0.4),
//                        heightDimension: .absolute(200)
//                    ),
//                    subitems: [item]
//                )
//
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
//
//                let header = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1.0),
//                        heightDimension: .absolute(150)),
//                    elementKind: UICollectionView.elementKindSectionHeader,
//                    alignment: .top
//                )
//
//                section.boundarySupplementaryItems = [header]
//                return section
//            }
//
//            if sectionIndex == 1 {
//                let item = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1.0),
//                        heightDimension: .fractionalHeight(1.0)
//                    )
//                )
//                let group = NSCollectionLayoutGroup.vertical(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1.0),
//                        heightDimension: .absolute(25)),
//                    subitems: [item]
//                )
//                let section = NSCollectionLayoutSection(group: group)
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 15, trailing: 0)
//                return section
//            }
//
//            // BROWSE LIST
//            let item = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .fractionalHeight(1.0)
//                )
//            )
//            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
//
//            let group = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .absolute(140)
//                ),
//                subitems: [item]
//            )
//
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
//            return section
//        }
//    }
//
//    // MARK: - Search
//    private func configureSearchController() {
//        let sc = UISearchController(searchResultsController: suggestionsVC)
//        sc.obscuresBackgroundDuringPresentation = false
//        sc.hidesNavigationBarDuringPresentation = true
//        sc.searchBar.placeholder = "Search plants"
//        sc.searchResultsUpdater = self
//        sc.searchBar.delegate = self
//        definesPresentationContext = true
//        self.searchController = sc
//
//        // Place search bar in navigation if available (safe)
//        if let _ = navigationController {
//            navigationItem.searchController = sc
//            navigationItem.hidesSearchBarWhenScrolling = false
//        } else {
//            // If no nav controller, you can insert the search bar into a header view later.
//            safePrint("ℹ️ No navigation controller present — search bar wasn't put into navigationItem.")
//        }
//
//        suggestionsVC.didSelectSuggestion = { [weak self] text in
//            guard let self = self else { return }
//            self.searchController.searchBar.text = text
//            self.searchController.isActive = false
//        }
//    }
//
//    // MARK: - Data source
//    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        if section == 0 { return PlantData.recommended.count }
//        if section == 1 { return 1 }
//        return PlantData.browse.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        // Use safe dequeue pattern and fall back to a default cell if cast fails.
//        if indexPath.section == 0 {
//            let dequeued = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath)
//            guard let cell = dequeued as? SearchCollectionViewCell else {
//                safePrint("⚠️ RecommendedCell is not of type SearchCollectionViewCell. Check the cell class/identifier in IB.")
//                return dequeued
//            }
//            let plant = PlantData.recommended[safe: indexPath.item] ?? PlantData.recommended.first
//            cell.nameLabel.text = plant?.name ?? "Unknown"
//            cell.taglineLabel.text = plant?.tagline ?? ""
//            if let name = plant?.imageName { cell.plantImageView.image = UIImage(named: name) }
//            cell.layer.cornerRadius = 12
//            cell.layer.borderWidth = 1
//            cell.layer.borderColor = UIColor.systemGray5.cgColor
//            return cell
//        }
//
//        if indexPath.section == 1 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath)
//        }
//
//        let dequeued = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseCell", for: indexPath)
//        guard let cell = dequeued as? Search_2CollectionViewCell else {
//            safePrint("⚠️ BrowseCell is not of type Search_2CollectionViewCell. Check the cell class/identifier in IB.")
//            return dequeued
//        }
//        if let plant = PlantData.browse[safe: indexPath.item] {
//            cell.nameLabel.text = plant.name
//            cell.plantImageView.image = UIImage(named: plant.imageName)
//            cell.maintenanceLabel.text = plant.maintenance
//            cell.lightLabel.text = plant.light
//            cell.waterLabel.text = plant.water
//        } else {
//            cell.nameLabel.text = "Unknown"
//            cell.maintenanceLabel.text = ""
//            cell.lightLabel.text = ""
//            cell.waterLabel.text = ""
//        }
//        cell.layer.cornerRadius = 20
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.systemGray5.cgColor
//        return cell
//    }
//
//    // Header supplementary view (safe dequeue)
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        guard kind == UICollectionView.elementKindSectionHeader,
//              indexPath.section == 0 else { return UICollectionReusableView() }
//
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                   withReuseIdentifier: "SearchHeaderView",
//                                                                   for: indexPath)
//        if let hv = view as? SearchHeaderView {
//            hv.delegate = self
//        } else {
//            safePrint("⚠️ Header view with identifier 'SearchHeaderView' isn't SearchHeaderView class. Check IB.")
//        }
//        return view
//    }
//
//    // MARK: - Scan menu
//    func presentMenuOptions(sourceView: UIView?) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Scan", style: .default) { _ in self.openCamera() })
//        alert.addAction(UIAlertAction(title: "Upload from Gallery", style: .default) { _ in self.openGallery() })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        if let pop = alert.popoverPresentationController, let v = sourceView {
//            pop.sourceView = v
//            pop.sourceRect = v.bounds
//        }
//        present(alert, animated: true)
//    }
//
//    func presentImagePicker(source: UIImagePickerController.SourceType) {
//        guard UIImagePickerController.isSourceTypeAvailable(source) else {
//            safePrint("⚠️ Image picker source not available: \(source)")
//            return
//        }
//        let picker = UIImagePickerController()
//        picker.sourceType = source
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//
//    private func openCamera() { presentImagePicker(source: .camera) }
//    private func openGallery() { presentImagePicker(source: .photoLibrary) }
//
//    // MARK: - Selection handling (defensive and simple)
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        safePrint("didSelectItemAt section:\(indexPath.section) item:\(indexPath.item)")
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        // Programmatic push that is safe
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        guard let vc = sb.instantiateViewController(withIdentifier: "PlantDetailViewController") as? PlantDetailViewController else {
//            safePrint("⚠️ Could not instantiate PlantDetailViewController. Check Storyboard ID and Custom Class.")
//            return
//        }
//
//        if indexPath.section == 0 {
//            if let item = PlantData.recommended[safe: indexPath.item] {
//                let model = PlantModel(
//                    name: item.name,
//                    description: item.tagline,
//                    benefit: nil,
//                    watering: item.imageName,
//                    sunlight: "Unknown",
//                    soil: "Unknown",
//                    imageURL: "Unknown"
//                )
//                vc.configure(with: model)
//            }
//        } else if indexPath.section == 2 {
//            if let p = PlantData.browse[safe: indexPath.item] {
//                let model = PlantModel(
//                    name: p.name,
//                    description: p.tagline.isEmpty ? p.maintenance : p.tagline,
//                    benefit: nil,
//                    watering: p.imageName,
//                    sunlight: p.water,
//                    soil: p.light,
//                    imageURL: p.maintenance
//                )
//                vc.configure(with: model)
//            }
//        } else {
//            safePrint("Tapped section \(indexPath.section) — no action.")
//            return
//        }
//
//        if let nav = navigationController {
//            nav.pushViewController(vc, animated: true)
//        } else {
//            present(vc, animated: true)
//        }
//    }
//
//    // MARK: - Image picker (scan flow)
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        guard let image = info[.originalImage] as? UIImage else {
//            picker.dismiss(animated: true)
//            return
//        }
//
//        picker.dismiss(animated: true) {
//            let hud = UIAlertController(title: nil, message: "Identifying…", preferredStyle: .alert)
//            self.present(hud, animated: true)
//
//            let identifier = PlantIdentifierLocal(modelFileName: "MyImageClassifier_2")
//
//            guard let id = identifier else {
//                hud.dismiss(animated: true) {
//                    let vc = IdentificationResultViewController(options: [("Unknown", 0.0)], image: image)
//                    self.present(vc, animated: true)
//                }
//                return
//            }
//
//            id.identify(image: image) { results in
//                DispatchQueue.main.async {
//                    hud.dismiss(animated: true) {
//                        let mappedResults: [(String, Float)] = results.map { r in
//                            if let tup = r as? (label: String, confidence: Float) {
//                                return (tup.label, tup.confidence)
//                            }
//                            return ("Unknown", 0)
//                        }
//
//                        let topN = Array(mappedResults.prefix(5))
//                        let vc = IdentificationResultViewController(options: topN, image: image)
//                        self.present(vc, animated: true)
//                    }
//                }
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//}
//
//// MARK: - UISearchResultsUpdating, UISearchBarDelegate
//extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        let text = searchController.searchBar.text ?? ""
//        guard !text.isEmpty else {
//            suggestionsVC.suggestions = []
//            return
//        }
//        let allNames: [String] = (PlantData.recommended.map { $0.name } + PlantData.browse.map { $0.name })
//        let lowered = text.lowercased()
//        let filtered = Array(Set(allNames.filter { $0.lowercased().contains(lowered) })).sorted()
//        suggestionsVC.suggestions = Array(filtered.prefix(10))
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchController.isActive = false
//    }
//}
//
//// MARK: - Safe collection index access extension
//fileprivate extension Array {
//    subscript(safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
