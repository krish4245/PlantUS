import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var careTypeCollectionView: UICollectionView!
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: UIView!

    @IBOutlet weak var card1: UIView!
    
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var statusCardView: UIView!
    @IBOutlet weak var totalPlantsCardView: UIView?
    @IBOutlet weak var spacesCardView: UIView?

    @IBOutlet weak var userSiteCount: UILabel!
    @IBOutlet weak var userPlantCount: UILabel!
    // MARK: - Data

    private let careTypes: [CareType] = [.watering, .trimming, .repotting, .fertilizing]
    private var selectedCareIndex: Int = 0

    private var plants: [Plant] = [
        Plant(name: "Monstera", subtitle: "Water Today", imageName: "Monsters", careType: .watering,
              wateringDone: false, sunlightDone: false, fertilizingDone: false),
        Plant(name: "Lil Sprout", subtitle: "Water Today", imageName: "lil_sprout", careType: .watering,
              wateringDone: false, sunlightDone: false, fertilizingDone: false),
        Plant(name: "Sunny S.", subtitle: "Water Today", imageName: "sunnys", careType: .watering,
              wateringDone: false, sunlightDone: false, fertilizingDone: false),
        Plant(name: "Fern Friend", subtitle: "Trim Today", imageName: "Monsters", careType: .trimming,
              wateringDone: false, sunlightDone: false, fertilizingDone: false),
        Plant(name: "Cactus Buddy", subtitle: "Trim Today", imageName: "indoor-plants-studio", careType: .trimming,
              wateringDone: false, sunlightDone: false, fertilizingDone: false)
    ]

    private var visiblePlants: [Plant] = []
    private var selectedPlant: Plant?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGreeting()
        
        careTypeCollectionView.dataSource = self
        careTypeCollectionView.delegate = self
        
        
        applyCareFilter(index: selectedCareIndex)
        setupCollectionViews()
        applyCareFilter(index: selectedCareIndex)
        updateHomeUI()
        styleCards()
        
        
        updateUserStats()


//        navigationItem.title = "Home"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//        scrollView.contentInsetAdjustmentBehavior = .never

        
        navigationController?.navigationBar.scrollEdgeAppearance =
            navigationController?.navigationBar.standardAppearance
        scrollView.alwaysBounceVertical = true

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlantCareCompleted),
            name: .plantCareCompleted,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserStats()
    }


    // MARK: - Setup
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())

        let greeting: String
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<21:
            greeting = "Good Evening"
        default:
            greeting = "Hello"
        }

        greetingLabel.text = greeting
    }

    
    func stylePlantCard(_ view: UIView) {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16

        // Subtle outline
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor

        // Very soft lift
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 2)

        view.layer.masksToBounds = false
    }
    
    private func updateUserStats() {
        let allUserPlants = PlantStore.shared.plants   // all UserPlant entries

        // ✅ Total plants including quantity
        let totalPlants = allUserPlants.reduce(0) { $0 + $1.quantity }
        userPlantCount.text = "\(totalPlants)"

        // ✅ Unique sites which contain plant quantity > 0
        let activeSiteIDs = Set(allUserPlants.filter { $0.quantity > 0 }.map { $0.siteID })
        userSiteCount.text = "\(activeSiteIDs.count)"
    }


    
    
    private func setupCollectionViews() {
        careTypeCollectionView.dataSource = self
        careTypeCollectionView.delegate = self

        plantsCollectionView.dataSource = self
        plantsCollectionView.delegate = self
    }

    private func applyCareFilter(index: Int) {
        let type = careTypes[index]
        visiblePlants = plants.filter { $0.careType == type }

        updateHomeUI()
        careTypeCollectionView.reloadData()
        plantsCollectionView.reloadData()
    }
    @objc private func handlePlantCareCompleted(notification: Notification) {
        guard let plantID = notification.object as? String else { return }

        plants.removeAll { $0.id == plantID }
        applyCareFilter(index: selectedCareIndex)
    }


    private func updateHomeUI() {
        let hasPlants = !visiblePlants.isEmpty
        plantsCollectionView.isHidden = !hasPlants
        emptyStateView.isHidden = hasPlants
    }

    // MARK: - Notifications


    // MARK: - UI Styling

    private func styleCards() {
        [card1, card2].forEach {
            $0?.layer.cornerRadius = 16
            $0?.layer.masksToBounds = true
        }

        let statCards = [totalPlantsCardView, spacesCardView]
        statCards.forEach {
            $0?.layer.cornerRadius = 18
            $0?.backgroundColor = UIColor(
                red: 0.90, green: 0.97, blue: 0.90, alpha: 1.0
            )
        }

        statusCardView.layer.cornerRadius = 18
        statusCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        statusCardView.layer.shadowOpacity = 1
        statusCardView.layer.shadowRadius = 10
        statusCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if collectionView == careTypeCollectionView {
            return careTypes.count
        } else {
            return visiblePlants.count
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12   // try 12–16
    }


    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        styleCards()
        if collectionView == careTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CareTypeCell",
                for: indexPath
            ) as! CareTypeCollectionViewCell

            let type = careTypes[indexPath.item]
            cell.configure(
                title: type.displayName,
                icon: type.icon,
                selected: indexPath.item == selectedCareIndex
            )
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlantCell",
                for: indexPath
            ) as! PlantCollectionViewCell

            let plant = visiblePlants[indexPath.item]
            cell.configure(with: plant)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        if collectionView == careTypeCollectionView {
            selectedCareIndex = indexPath.item
            applyCareFilter(index: selectedCareIndex)

        } else {
            selectedPlant = visiblePlants[indexPath.item]

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(
                withIdentifier: "PlantCareModalViewController"
            ) as! PlantCareModalViewController

            vc.plant = selectedPlant
           
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
           
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == careTypeCollectionView {
            let title = careTypes[indexPath.item].displayName
            let width = title.size(withAttributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .medium)
            ]).width
            return CGSize(width: width + 52, height: 40)
        } else {
            return CGSize(width: 140, height: 170)
        }
    }
}
