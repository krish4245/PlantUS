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

    
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    @IBOutlet weak var wateringButton: UIButton!
    
    @IBOutlet weak var repottingButton: UIButton!
    
    @IBOutlet weak var pruningButton: UIButton!
    
    @IBOutlet weak var fertilizingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        refreshButtonStates()
        setupUI()
        
    }
    
    @IBAction func markWateringDone(_ sender: UIButton) {
        updateTask(.watering, sender: sender)
    }
    @IBAction func markRepotDone(_ sender: UIButton) {
        updateTask(.repotting               , sender: sender)
    }
    @IBAction func markPruningDone(_ sender: UIButton) {
        updateTask(.trimming, sender: sender)
    }
    
    @IBAction func markFertilizingDone(_ sender: UIButton) {
        updateTask(.fertilizing, sender: sender)
    }
    
    private func setupUI(){
        plantNameLabel.text = plantModel?.name ?? "Plant"
        siteNameLabel.text = "Location: \(userPlant?.siteName ?? "Unknown")"
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

        //  get updated plant state from store
        guard let updatedUserPlant = PlantStore.shared.plants.first(where: { $0.id == id }) else { return }
        self.userPlant = updatedUserPlant

        setDoneUI(for: wateringButton, isDone: updatedUserPlant.wateringDone)
        setDoneUI(for: pruningButton, isDone: updatedUserPlant.pruningDone)
        setDoneUI(for: repottingButton, isDone: updatedUserPlant.repottingDone)
        setDoneUI(for: fertilizingButton, isDone: updatedUserPlant.fertilizingDone)
    }

    private func setDoneUI(for button: UIButton, isDone: Bool) {
        if isDone {
            button.setTitle("Done", for: .normal)
            button.isEnabled = false
            button.alpha = 0.6
        } else {
            //button.setTitle(title, for: .normal)
            button.isEnabled = true
            button.alpha = 1.0
        }
    }

}

