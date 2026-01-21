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

    
        fetchPlant()
        setupUI()
        print("Received plant ID:", plantId!)
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

}
