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

           scoreHighlightView.layer.cornerRadius = 20
           scoreHighlightView.layer.masksToBounds = true
      
    }
    
    private func styleGreenBox() {
        scoreHighlightView.backgroundColor = UIColor(red: 0.90, green: 0.97, blue: 0.90, alpha: 1.0) // soft green
        scoreHighlightView.layer.cornerRadius = 18
        scoreHighlightView.layer.masksToBounds = true
    }
}
