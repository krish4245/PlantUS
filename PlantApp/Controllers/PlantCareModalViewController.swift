//
//  PlantCareModalViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 13/12/25.
//

import UIKit

class PlantCareModalViewController: UIViewController {

    
    var userPlant: UserPlant?
    var plantModel: PlantModel_Ved?

//    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    @IBOutlet weak var wateringButton: UIButton!
    
    @IBOutlet weak var repottingButton: UIButton!
    
    @IBOutlet weak var pruningButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plantModel?.name ?? "Plant"
        //        if let sheet = sheetPresentationController {
        //              sheet.detents = [.medium(), .large()]
        //              sheet.prefersGrabberVisible = true
        //              sheet.preferredCornerRadius = 24
        //          }
        
        refreshButtonStates()
        
    }
    
    @IBAction func markWateringDoneTapped(_ sender: UIButton) {
        updateTask(.watering, sender: sender)
    }
    @IBAction func markRepotDoneTapped(_ sender: UIButton) {
        updateTask(.repotting               , sender: sender)
    }
    @IBAction func markPruningDoneTapped(_ sender: UIButton) {
        updateTask(.trimming, sender: sender)
    }
   
    
    private func updateTask(_ careType: CareType, sender: UIButton) {
          guard let userPlantID = userPlant?.id else { return }

          // Update in PlantStore (source of truth)
          PlantStore.shared.markTaskDone(userPlantID: userPlantID, careType: careType)

          sender.setTitle("Done", for: .normal)
          sender.isEnabled = false

          NotificationCenter.default.post(name: .plantCareCompleted, object: nil)
          
      }
    
    private func refreshButtonStates() {
        guard let id = userPlant?.id else { return }

        // ✅ get updated plant state from store
        guard let updatedUserPlant = PlantStore.shared.plants.first(where: { $0.id == id }) else { return }
        self.userPlant = updatedUserPlant

        setDoneUI(for: wateringButton, isDone: updatedUserPlant.wateringDone)
        setDoneUI(for: pruningButton, isDone: updatedUserPlant.pruningDone)
        setDoneUI(for: repottingButton, isDone: updatedUserPlant.repottingDone)
    }

    private func setDoneUI(for button: UIButton, isDone: Bool) {
        if isDone {
            button.setTitle("Done", for: .normal)
            button.isEnabled = false
            button.alpha = 0.6
        } else {
//            button.setTitle(title, for: .normal)
            button.isEnabled = true
            button.alpha = 1.0
        }
    }
    
    // homescreen popup dismiss
    
 

    
  
     
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

