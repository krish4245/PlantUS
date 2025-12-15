//
//  GardenScoreViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class GardenScoreViewController: UIViewController {

    @IBOutlet weak var healthyIconBackgroundView: UIView!
    @IBOutlet weak var metricCard1View: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        metricCard1View.layer.cornerRadius = 16
           metricCard1View.layer.masksToBounds = true

           healthyIconBackgroundView.layer.cornerRadius = 20   // half of 40
           healthyIconBackgroundView.layer.masksToBounds = true
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
