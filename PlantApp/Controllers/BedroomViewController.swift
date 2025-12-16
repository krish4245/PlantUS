//
//  BedroomViewController.swift
//  p
//
//  Created by SDC-USER on 13/12/25.
//

import UIKit

class BedroomViewController: UIViewController {
    var site: MyGardenSite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = site.name
     
    }
    @IBAction func monsteraCardTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showMonsteraDetail", sender: nil)
    }
}
