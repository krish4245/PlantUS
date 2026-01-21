//
//  GardenScoreViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class GardenScoreViewController: UIViewController {
    @IBOutlet weak var scoreHighlightView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleGreenBox()
        scoreHighlightView.layer.cornerRadius = 16
           scoreHighlightView.layer.masksToBounds = true

           scoreHighlightView.layer.cornerRadius = 20   // half of 40
           scoreHighlightView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    private func styleGreenBox() {
        scoreHighlightView.backgroundColor = UIColor(red: 0.90, green: 0.97, blue: 0.90, alpha: 1.0) // soft green
        scoreHighlightView.layer.cornerRadius = 18
        scoreHighlightView.layer.masksToBounds = true
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
