//
//  TestHomeViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 13/01/26.
//

import UIKit

class TestHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var userSiteCount: UILabel!
    @IBOutlet weak var userPlantCount: UILabel!
    
    @IBOutlet weak var card1: UIView!
    
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var statusCardView: UIView!



    
    @IBOutlet weak var collectionView: UICollectionView!
    private let careTypes: [CareType_ved] = [
        CareType_ved(
            title: "Watering",
            icon: "drop.fill",
            
            gradientColors: [
                UIColor(red: 0.78, green: 0.90, blue: 1.00, alpha: 1.0),
                UIColor(red: 0.92, green: 0.97, blue: 1.00, alpha: 1.0),
              
                
            ],  kind : .watering,
        ),
        CareType_ved(
            title: "Repotting",
            icon: "leaf.fill",
            gradientColors: [
                UIColor(red: 0.76, green: 0.95, blue: 0.84, alpha: 1.0),
                UIColor(red: 0.93, green: 1.00, blue: 0.96, alpha: 1.0)
            ],  kind : .repotting,
        ),
        CareType_ved(
            title: "Fertilizing",
            icon: "aqi.low",
            gradientColors: [
                UIColor(red: 1.00, green: 0.88, blue: 0.70, alpha: 1.0),
                UIColor(red: 1.00, green: 0.96, blue: 0.86, alpha: 1.0)
            ],  kind : .fertilizing,
        ),
        CareType_ved(
            title: "Pruning",
            icon: "scissors",
            gradientColors: [
                UIColor(red: 0.86, green: 0.86, blue: 0.92, alpha: 1.0),
                UIColor(red: 0.96, green: 0.96, blue: 1.00, alpha: 1.0)
            ],  kind : .trimming,
        )
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerCell()
        updateGreeting()
        collectionView.collectionViewLayout = createCareGridLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        styleStatusCard()
        updateUserStats()
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
    
    
    private func createCareGridLayout() -> UICollectionViewLayout {
           let layout = UICollectionViewFlowLayout()

           let spacing: CGFloat = 10
           let totalSpacing = spacing * 3 // left + middle + right

           let cellWidth = (UIScreen.main.bounds.width - totalSpacing - 32) / 2
           layout.itemSize = CGSize(width: cellWidth, height: 120)

           layout.minimumLineSpacing = spacing
           layout.minimumInteritemSpacing = spacing
//           layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

           return layout
       }
    
    
    
    func registerCell(){
        collectionView.register(TimeCareCell.nib(), forCellWithReuseIdentifier: TimeCareCell.identifier)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return careTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeCareCell.identifier,
                   for: indexPath
               ) as? TimeCareCell else {
                   return UICollectionViewCell()
               }

               cell.configure(with: careTypes[indexPath.row])
               return cell
    }
    
    private func styleStatusCard() {
        statusCardView.backgroundColor = .systemBackground
        statusCardView.layer.cornerRadius = 18
        statusCardView.clipsToBounds = true

        statusCardView.layer.shadowColor = UIColor.black.cgColor
        statusCardView.layer.shadowOpacity = 0.08
        statusCardView.layer.shadowRadius = 12
        statusCardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        statusCardView.layer.masksToBounds = false
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let selectedType = careTypes[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "CareDetailViewController"
        ) as? CareDetailViewController else { return }

        vc.pageTitle = selectedType.title
        vc.careKind = selectedType.kind

        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openCareDetail(title: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "CareDetail"
        ) as? CareDetailViewController else { return }

        vc.pageTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
