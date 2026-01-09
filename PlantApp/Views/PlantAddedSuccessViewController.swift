//
//  PlantAddedSuccessViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 09/01/26.
//

import UIKit

class PlantAddedSuccessViewController: UIViewController {

    @IBAction func doneButtonTapped(_ sender: UIButton) {
            navigationController?.popToRootViewController(animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
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
