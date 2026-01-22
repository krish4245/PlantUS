import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var careTypeCollectionView: UICollectionView!
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: UIView!

    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var gardenStatusContainerView: UIView!
    @IBOutlet weak var wateringContainerView: UIView!
  

    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var statusCardView: UIView!
    @IBOutlet weak var totalPlantsCardView: UIView?
    @IBOutlet weak var spacesCardView: UIView?

    @IBOutlet weak var userSiteCount: UILabel!
    @IBOutlet weak var userPlantCount: UILabel!
    // MARK: - Data

    private let careTypes: [CareType] = [.watering, .trimming, .repotting, .fertilizing]
    private var selectedCareIndex: Int = 0
    
    private var visibleUserPlants: [UserPlant] = []
    private var selectedUserPlant: UserPlant?



    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGreeting()
        setupCollectionViews()
        applyCareFilter(index: selectedCareIndex)
        updateHomeUI()
        styleCards()
        
        
        updateUserStats()




        
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
        applyCareFilter(index: selectedCareIndex)
    }


    // MARK: - Greeting
    
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

        //  Total plants including quantity
        let totalPlants = allUserPlants.reduce(0) { $0 + $1.quantity }
        userPlantCount.text = "\(totalPlants)"

        // Unique sites which contain plant quantity > 0
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
        let selectedType = careTypes[index]
        
        let allUserPlants = PlantStore.shared.plants

        
        visibleUserPlants = allUserPlants.filter { userPlant in
            userPlant.isAddedToGarden == true  && userPlant.quantity > 0 && isPendingTask(for: userPlant, careType: selectedType)
        }

        updateHomeUI()
        careTypeCollectionView.reloadData()
        plantsCollectionView.reloadData()
    }
    
    
    private func isPendingTask(for plant: UserPlant, careType: CareType) -> Bool {
        switch careType {
        case .watering:
            return plant.wateringDone == false
        case .trimming:
                   return plant.pruningDone == false
        case .fertilizing:
                   return plant.fertilizingDone == false
        case .repotting:
                   return plant.repottingDone == false
        }
    }
    
    private func getPlantModel ( for userPlant: UserPlant) -> PlantModel_Ved? {
        return PlantDataSource.shared.allPlants.first { $0.id == userPlant.plantId}
    }
    
    @objc private func handlePlantCareCompleted(notification: Notification) {

        applyCareFilter(index: selectedCareIndex)
    }


    private func updateHomeUI() {
        let hasPlants = !visibleUserPlants.isEmpty
        plantsCollectionView.isHidden = !hasPlants
        emptyStateView.isHidden = hasPlants
    }

  


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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlantCareModal" {

            guard let vc = segue.destination as? PlantCareModalViewController else { return }
            guard let userPlant = selectedUserPlant else { return }
            guard let plantModel = getPlantModel(for: userPlant) else { return }

            vc.userPlant = userPlant
            vc.plantModel = plantModel

//             Modal sheet style settings
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                      sheet.detents = [
                          .medium(),   // half screen
                      ]
                      sheet.prefersGrabberVisible = true
                   
                      sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                  }

        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if collectionView == careTypeCollectionView {
            return careTypes.count
        } else {
            return visibleUserPlants.count
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12   
    }


    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
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
            
            let userPlant = visibleUserPlants[indexPath.item]
            let careType = careTypes[selectedCareIndex]
            
            if let plantModel = getPlantModel(for: userPlant) {
                cell.configure(with: plantModel, userPlant: userPlant,careType: careType)
            }else{
                cell.nameLabel.text = "Unknown Plant"
                cell.subtitleLabel.text = ""
                   cell.plantImageView.image = UIImage(named: "placeholder")
            }


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
            selectedUserPlant = visibleUserPlants[indexPath.item]
               performSegue(withIdentifier: "showPlantCareModal", sender: self)
           
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
