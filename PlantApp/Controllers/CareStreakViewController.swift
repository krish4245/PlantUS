//
//  WateringConsistencyViewController.swift
//  p
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class CareStreakViewController: UIViewController {

    @IBOutlet weak var currentStreak: UIImageView!
    @IBOutlet weak var BestStreak: UIImageView!
    
    @IBOutlet weak var ThisMonth: UIImageView!
    @IBOutlet weak var OrangeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentStreak.layer.cornerRadius = 20
        currentStreak.layer.masksToBounds = true
        
        
        BestStreak.layer.cornerRadius = 20
        BestStreak.layer.masksToBounds = true
        
        ThisMonth.layer.cornerRadius = 20
        ThisMonth.layer.masksToBounds = true
        
        OrangeView.layer.cornerRadius = 16
        OrangeView.layer.masksToBounds = true

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

