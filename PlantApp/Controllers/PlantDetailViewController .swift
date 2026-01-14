//
//  PlantDetailViewController 2.swift
//  Sample_searchPage
//
//  Created by vedant on 03/01/26.
//


import UIKit

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var benefitsCardView: UIStackView!
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var planTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
  
    @IBOutlet weak var lightButton: UIButton!
    
    @IBOutlet weak var waterButton: UIButton!
    
    @IBOutlet weak var BenifitsCardView: UIStackView!
    
    var plantId: String!   // RECEIVED FROM PREVIOUS SCREEN
      private var plant: PlantModel_Ved?

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        styleBenefitsCard()
        // Do any additional setup after loading the view.
        styleCard(benefitsCardView)
        fetchPlant()
        setupUI()
        print("Received plant ID:", plantId!)
    }
    
    private func styleCard(_ view: UIView) {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowRadius = 18
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

    
    private func fetchPlant() {
          plant = PlantDataSource.shared.allPlants.first {
              $0.id == plantId
          }
      }
    
    private func setupUI() {
          guard let plant = plant else { return }

          planTitleLabel.text = plant.name
          descriptionLabel.text = plant.description

        lightButton.setTitle(plant.light, for: .normal)
        waterButton.setTitle(plant.water, for: .normal)

          plantImageView.image = UIImage(named: plant.imageName)
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toPlantQuestions" {

            let destinationVC = segue.destination
                as! Add_plant_q1_ViewController

            destinationVC.plantId = plantId
        }
    }
// modal after search plant if any plant is tapped
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
