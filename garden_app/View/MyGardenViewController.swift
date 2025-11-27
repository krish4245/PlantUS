//
//  MyGardenViewController.swift
//  garden_app
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit

class MyGardenViewController: UIViewController {

    @IBOutlet weak var bedroomCardView: UIView!
       @IBOutlet weak var livingRoomCardView: UIView!
       @IBOutlet weak var balconyCardView: UIView!
       @IBOutlet weak var windowSillCardView: UIView!
       @IBOutlet weak var kitchenCardView: UIView!
       @IBOutlet weak var officeCardView: UIView!
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
        styleCards()
        // Do any additional setup after loading the view.
    }

        private func styleCards() {
            let cards = [
                bedroomCardView,
                livingRoomCardView,
                balconyCardView,
                windowSillCardView,
                kitchenCardView,
                officeCardView
            ]

            for card in cards {
                guard let card = card else { continue }
                card.layer.cornerRadius = 24
                card.layer.masksToBounds = true
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


