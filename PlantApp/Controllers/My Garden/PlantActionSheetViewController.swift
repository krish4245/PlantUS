//
//  PlantActionSheetViewController.swift
//  PlantApp
//
//  Created by vedant on 11/01/26.
//

import UIKit

class PlantActionSheetViewController: UIViewController {
    
    var userPlant: UserPlant!

    var onUpdate: (() -> Void)?

    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var removeOneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        

        // Do any additional setup after loading the view.
    }
    
    
    private func setupUI(){
        let plantModel = PlantDataSource.shared.plant(for: userPlant.plantId)
        let qty = userPlant.quantity
        
        
        plantNameLabel.text = plantModel?.name
            //show quantity
        quantityLabel.text = "Quantity: \(qty)"

        
        if qty > 1 {
                   removeOneButton.isEnabled = true
                   removeOneButton.alpha = 1.0
               } else {
                   removeOneButton.isEnabled = false
                   removeOneButton.alpha = 0.4
               }
        
        
        
    }
    
    @IBAction func removeOneTapped(_ sender: UIButton) {
        
        PlantStore.shared.removeOnePlant(
                   plantId: userPlant.plantId,
                   siteID: userPlant.siteID
               )

               onUpdate?()
               dismiss(animated: true)
    }
    
    
    @IBAction func removeAllTapped(_ sender: UIButton) {
        
        PlantStore.shared.removeAllPlants(
                   plantId: userPlant.plantId,
                   siteID: userPlant.siteID
               )

               onUpdate?()
               dismiss(animated: true)
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
