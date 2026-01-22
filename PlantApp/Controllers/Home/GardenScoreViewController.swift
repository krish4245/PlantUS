//
//  GardenScoreViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class GardenScoreViewController: UIViewController {
    
    
    @IBOutlet weak var scoreHighlightView: UIView!
    
    @IBOutlet weak var healthyPlantsLabel: UILabel!
    
    @IBOutlet weak var needsAttentionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleGreenBox()
        scoreHighlightView.layer.cornerRadius = 16
           scoreHighlightView.layer.masksToBounds = true

           scoreHighlightView.layer.cornerRadius = 20
           scoreHighlightView.layer.masksToBounds = true
            
        updateUserStats()
      
    }
    
    private func styleGreenBox() {
        scoreHighlightView.backgroundColor = UIColor(red: 0.90, green: 0.97, blue: 0.90, alpha: 1.0) // soft green
        scoreHighlightView.layer.cornerRadius = 18
        scoreHighlightView.layer.masksToBounds = true
    }
    
    private func updateUserStats() {
        let allUserPlants = PlantStore.shared.plants
        
        let totalPlants = allUserPlants.reduce(0) { $0 + $1.quantity }
        
        let needsAttentionPlants = allUserPlants.reduce(0) { result, plant in
               let needsAttention = (!plant.wateringDone ||
                                     !plant.pruningDone ||
                                     !plant.fertilizingDone ||
                                     !plant.repottingDone)

               return result + (needsAttention ? plant.quantity : 0)
           }
        
        healthyPlantsLabel.text = "\(totalPlants - needsAttentionPlants)"
          needsAttentionLabel.text = "\(needsAttentionPlants)"
    }
}
