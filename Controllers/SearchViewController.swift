//
//  SearchViewController.swift
//  garden_app
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

// Added UICollectionViewDataSource and UICollectionViewDelegate

// MARK: - Search properties
private var searchController: UISearchController!
private let suggestionsVC = SearchSuggestionsViewController()

// filtered data for browse section (section 2)
private var filteredBrowse: [BrowsePlant] = [] // BrowsePlant is the PlantData.browse item type
private var isSearching: Bool {
    let text = searchController?.searchBar.text ?? ""
    return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SearchHeaderViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func searchHeaderDidTapMenu(_ header: SearchHeaderView) {
        presentMenuOptions(sourceView: header.menuButton)
    }

    // MARK: - Outlets
    // Don't forget to connect this in Storyboard!
    @IBOutlet weak var collectionView: UICollectionView!

    private var recentPredictions: [String] = []
    private let smoothingWindow = 5

    private func addPrediction(_ label: String) -> String {
        recentPredictions.append(label)
        if recentPredictions.count > smoothingWindow { recentPredictions.removeFirst() }
        // return most frequent
        let counts = Dictionary(grouping: recentPredictions, by: { $0 }).mapValues { $0.count }
        return counts.max(by: { $0.value < $1.value })?.key ?? label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()

        configureSearchController()
        filteredBrowse = PlantData.browse
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Search setup
    private func configureSearchController() {
        // Wire suggestions VC callback
        suggestionsVC.didSelectSuggestion = { [weak self] suggestion in
            guard let self = self else { return }
            self.searchController.searchBar.text = suggestion
            self.applySearch(text: suggestion)
            // Dismiss suggestions
            self.searchController.isActive = false
        }

        // Create search controller with suggestionsVC as results
        searchController = UISearchController(searchResultsController: suggestionsVC)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .yes
        searchController.searchBar.placeholder = "Search plants"
        searchController.searchBar.delegate = self

        // If you use a visible navigation bar, you would set:
        // navigationItem.searchController = searchController
        // navigationItem.hidesSearchBarWhenScrolling = false
        //
        // Since the nav bar is hidden in this screen, we still keep the controller
        // to drive suggestions and filtering. You may also embed a UISearchBar in your header view if desired.

        definesPresentationContext = true
    }

    // MARK: - Search updating
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        // Update suggestions
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            suggestionsVC.suggestions = []
            filteredBrowse = PlantData.browse
            collectionView.reloadData()
            return
        }

        // Simple suggestion source: names from PlantData.browse
        let names = PlantData.browse.map { $0.name }
        let suggestions = names.filter { $0.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil }
        suggestionsVC.suggestions = Array(suggestions.prefix(10))

        // Apply filter to the browse list live
        applySearch(text: trimmed)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        applySearch(text: text)
        searchController.isActive = false
    }

    private func applySearch(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            filteredBrowse = PlantData.browse
        } else {
            filteredBrowse = PlantData.browse.filter {
                $0.name.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.maintenance.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.light.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.water.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
        }
        collectionView.reloadSections(IndexSet(integer: 2))
    }

    // MARK: - Layout Logic
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            if sectionIndex == 0 {
                // RECOMMENDED HORIZONTAL
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 0, trailing: 2)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                       heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section

            } else if sectionIndex == 1 {
                // TITLE
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(25))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 15, trailing: 0)
                return section

            } else {
                // BROWSE LIST
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(140))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
                return section
            }
        }
    }

    // MARK: - Collection Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return PlantData.recommended.count }
        if section == 1 { return 1 }
        // Use filtered list while searching
        return isSearching ? filteredBrowse.count : PlantData.browse.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! SearchCollectionViewCell
            let plant = PlantData.recommended[indexPath.row]
            cell.nameLabel.text = plant.name
            cell.taglineLabel.text = plant.tagline
            cell.plantImageView.image = UIImage(named: plant.imageName)
            cell.layer.cornerRadius = 12
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            return cell

        } else if indexPath.section == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath)

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseCell", for: indexPath) as! Search_2CollectionViewCell
            let plant = (isSearching ? filteredBrowse : PlantData.browse)[indexPath.row]
            cell.nameLabel.text = plant.name
            cell.plantImageView.image = UIImage(named: plant.imageName)
            cell.maintenanceLabel.text = plant.maintenance
            cell.lightLabel.text = plant.light
            cell.waterLabel.text = plant.water
            cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            return cell
        }
    }

    // Header
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, indexPath.section == 0 else {
            return UICollectionReusableView()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "SearchHeaderView",
                                                                         for: indexPath)
        if let searchHeader = headerView as? SearchHeaderView {
            searchHeader.delegate = self
        }
        return headerView
    }

    // MARK: - Header delegate (menu)
    func presentMenuOptions(sourceView: UIView?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Scan", style: .default, handler: { [weak self] _ in self?.openCamera() }))
        alert.addAction(UIAlertAction(title: "Upload from Gallery", style: .default, handler: { [weak self] _ in self?.openGallery() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let pop = alert.popoverPresentationController, let v = sourceView {
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
        present(alert, animated: true)
    }

    // MARK: - Image Picker Helpers
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            let msg = source == .camera ? "Camera not available" : "Photo library not available"
            let err = UIAlertController(title: "Unavailable", message: msg, preferredStyle: .alert)
            err.addAction(UIAlertAction(title: "OK", style: .default))
            present(err, animated: true)
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = false
        DispatchQueue.main.async { self.present(picker, animated: true) }
    }

    private func openCamera() { presentImagePicker(source: .camera) }
    private func openGallery() { presentImagePicker(source: .photoLibrary) }

    // MARK: - UIImagePickerControllerDelegate (robust)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("[Identify] imagePickerController called")

        // 1) extract image
        guard let image = info[.originalImage] as? UIImage else {
            print("[Identify] No image from picker")
            picker.dismiss(animated: true) {
                let err = UIAlertController(title: "Error", message: "No image was selected.", preferredStyle: .alert)
                err.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(err, animated: true)
            }
            return
        }

        // 2) dismiss picker then continue inside completion to avoid presentation race
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            print("[Identify] picker dismissed — proceeding")

            // Wait for any presented VC to disappear (rare race)
            func waitForPresentationToFinish(completion: @escaping () -> Void) {
                var attempts = 0
                let maxAttempts = 10
                let checkInterval: TimeInterval = 0.1
                func check() {
                    attempts += 1
                    if self.presentedViewController == nil { completion() }
                    else if attempts >= maxAttempts {
                        self.presentedViewController?.dismiss(animated: false, completion: completion)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + checkInterval, execute: check)
                    }
                }
                check()
            }

            waitForPresentationToFinish {
                // Present HUD
                let hud = UIAlertController(title: nil, message: "Identifying…", preferredStyle: .alert)
                self.present(hud, animated: true) {
                    print("[Identify] HUD presented")
                }

                // safety timeout
                var didFinish = false
                let timeoutSeconds: TimeInterval = 12.0
                DispatchQueue.main.asyncAfter(deadline: .now() + timeoutSeconds) {
                    if !didFinish {
                        print("[Identify] Identification timed out — dismissing HUD and showing fallback")
                        hud.dismiss(animated: true) {
                            let vc = IdentificationResultViewController(options: [("Unknown", 0.0)], image: image)
                            vc.onViewDetail = { q in if let q = q { self.searchQueryFor(name: q) } }
                            self.present(vc, animated: true)
                        }
                    }
                }

                // Try to load model
                let identifier = PlantIdentifierLocal(modelFileName: "MyImageClassifier 1")
                guard let id = identifier else {
                    print("[Identify] Model not found in bundle; showing fallback")
                    didFinish = true
                    hud.dismiss(animated: true) {
                        let vc = IdentificationResultViewController(options: [("Unknown", 0.0)], image: image)
                        vc.onViewDetail = { q in if let q = q { self.searchQueryFor(name: q) } }
                        self.present(vc, animated: true)
                    }
                    return
                }

                // Run identify (assumes id.identify(image:completion:) returns [(label:String, confidence:Float)])
                id.identify(image: image) { [weak self] results in
                    guard let self = self else { return }
                    didFinish = true
                    print("[Identify] Raw results:", results)

                    // Convert results to label/conf pair array
                    // If the identify completion uses VNClassificationObservation or another type,
                    // adapt this mapping accordingly.
                    let mappedResults: [(String, Float)] = results.map { r in
                        // r may be a tuple or custom type; try to handle both common shapes:
                        if let tup = r as? (label: String, confidence: Float) {
                            return (tup.label, tup.confidence)
                        }
                        // if r is a dictionary-like or custom object, attempt KVC
                        if let dict = r as? [String: Any],
                           let lbl = dict["label"] as? String,
                           let conf = dict["confidence"] as? Float {
                            return (lbl, conf)
                        }
                        // fallback attempt for objects with properties `identifier` and `confidence`
                        if let obs = r as? NSObject,
                           let lbl = obs.value(forKey: "identifier") as? String,
                           let confVal = obs.value(forKey: "confidence") as? NSNumber {
                            return (lbl, confVal.floatValue)
                        }
                        // last resort (try Swift tuple-like)
                        if let pair = r as? (String, Float) {
                            return pair
                        }
                        // unknown shape -> represent minimally
                        return ("Unknown", 0.0)
                    }

                    // Build topN (non-empty)
                    let topN = Array(mappedResults.prefix(5))
                    if topN.isEmpty {
                        let vc = IdentificationResultViewController(options: [("Unknown", 0.0)], image: image)
                        vc.onViewDetail = { q in if let q = q { self.searchQueryFor(name: q) } }
                        self.present(vc, animated: true)
                        return
                    }

                    // Map raw label -> app display name (LabelMapper)
                    let mappedTop: [(String, Float)] = topN.map { raw, conf in
                        let display = LabelMapper.appName(from: raw) ?? raw
                        return (display, conf)
                    }

                    // Apply smoothing on the top label
                    let topLabelRaw = mappedTop.first?.0 ?? "Unknown"
                    let smoothed = self.addPrediction(topLabelRaw)
                    print("[Identify] Top:", mappedTop, " Smoothed:", smoothed)

                    // Prepare options to show: ensure top item is the smoothed one if present
                    var optionsToShow = mappedTop
                    if optionsToShow.first?.0.lowercased() != smoothed.lowercased() {
                        // reorder if smoothed present in options
                        if let idx = optionsToShow.firstIndex(where: { $0.0.lowercased() == smoothed.lowercased() }) {
                            let chosen = optionsToShow.remove(at: idx)
                            optionsToShow.insert(chosen, at: 0)
                        } else {
                            // if smoothed not in top set, insert it (unknown confidence)
                            optionsToShow.insert((smoothed, mappedTop.first?.1 ?? 0.0), at: 0)
                            if optionsToShow.count > 5 { optionsToShow.removeLast() }
                        }
                    }

                    // Always present the IdentificationResultViewController (showing names + confidences)
                    hud.dismiss(animated: true) {
                        let vc = IdentificationResultViewController(options: optionsToShow, image: image)
                        vc.onViewDetail = { chosen in
                            if let chosen = chosen {
                                self.openPlantDetail(for: chosen)
                            }
                        }
                        self.present(vc, animated: true)
                    }
                } // end identify completion
            } // end waitForPresentationToFinish
        } // end picker.dismiss completion
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Open plant detail or search
    func openPlantDetail(for mappedName: String) {
        // Try to find a matching PlantData entry (case-insensitive)
        if let browse = PlantData.browse.first(where: { $0.name.lowercased() == mappedName.lowercased() }) {
            let plant = Plant(name: browse.name,
                              subtitle: browse.tagline.isEmpty ? browse.maintenance : browse.tagline,
                              imageName: browse.imageName,
                              careType: .watering)
            let detailVC = PlantDetailViewController.instantiate(from: self.storyboard, withPlant: plant)
            detailVC.modalPresentationStyle = .fullScreen
            self.present(detailVC, animated: true)
        } else {
            // fallback: fill search bar
            searchQueryFor(name: mappedName)
        }
    }

    // MARK: - Collection selection (tap)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedBrowsePlant: BrowsePlant?
        switch indexPath.section {
        case 0: selectedBrowsePlant = PlantData.recommended[indexPath.item]
        case 1: selectedBrowsePlant = nil
        default: selectedBrowsePlant = PlantData.browse[indexPath.item]
        }
        guard let browse = selectedBrowsePlant else { return }

        let subtitle: String = {
            if !browse.tagline.isEmpty { return browse.tagline }
            return [browse.maintenance, browse.light, browse.water].filter { !$0.isEmpty }.joined(separator: " • ")
        }()

        let selectedPlant = Plant(name: browse.name, subtitle: subtitle, imageName: browse.imageName, careType: .watering)
        let detailVC = PlantDetailViewController.instantiate(from: storyboard, withPlant: selectedPlant)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }

    // MARK: - Search Setup
    private func configureSearchController() {
        let controller = UISearchController(searchResultsController: suggestionsVC)
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "Search plants"
        searchController = controller
        definesPresentationContext = true
    }

    // MARK: - Utility: prefill search or fallback
    private func searchQueryFor(name: String) {
        if let sc = navigationItem.searchController {
            sc.searchBar.text = name
            if let updater = sc.searchResultsUpdater as? UISearchResultsUpdating {
                updater.updateSearchResults(for: sc)
            }
        } else {
            print("Search fallback query:", name)
        }
    }

    // MARK: - Debug helper
    func debugSimulateIdentification() {
        let dummyImage = UIImage(named: "monstera_sample") ?? UIImage()
        let vc = IdentificationResultViewController(options: [("Monstera", 0.92), ("Philodendron", 0.05), ("Pilea", 0.02)], image: dummyImage)
        vc.onViewDetail = { name in
            if let n = name { print("simulate view detail for", n) }
        }
        present(vc, animated: true)
    }
}

