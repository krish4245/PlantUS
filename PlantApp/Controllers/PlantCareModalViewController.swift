//
//  PlantCareModalViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 13/12/25.
//

import UIKit

class PlantCareModalViewController: UIViewController {

    var plant: Plant!

//    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    @IBAction func markWateringDoneTapped(_ sender: UIButton) {
        plant.wateringDone = true
        sender.setTitle("Done", for: .normal)
        sender.isEnabled = false
        checkIfAllDone()
    }
    @IBAction func markSunlightDoneTapped(_ sender: UIButton) {
        plant.sunlightDone = true
        sender.setTitle("Done", for: .normal)
        sender.isEnabled = false
        checkIfAllDone()
    }
    @IBAction func markFertilizingDoneTapped(_ sender: UIButton) {
        plant.fertilizingDone = true
        sender.setTitle("Done", for: .normal)
        sender.isEnabled = false
        checkIfAllDone()
    }
    func checkIfAllDone() {
        if plant.wateringDone &&
           plant.sunlightDone &&
           plant.fertilizingDone {
            notifyHomeAndDismiss()
        }
    }
    
    func notifyHomeAndDismiss() {
        NotificationCenter.default.post(
            name: .plantCareCompleted,
            object: plant.id
        )

        dismiss(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plant.name
        //        if let sheet = sheetPresentationController {
        //              sheet.detents = [.medium(), .large()]
        //              sheet.prefersGrabberVisible = true
        //              sheet.preferredCornerRadius = 24
        //          }
        
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

