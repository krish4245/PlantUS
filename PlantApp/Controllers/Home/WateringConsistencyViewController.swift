//
//  WateringConsistencyViewController.swift
//  p
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class WateringConsistencyViewController: UIViewController {

    @IBOutlet weak var currentStreak: UIImageView!
    @IBOutlet weak var NeedsAttention: UIImageView!
    @IBOutlet weak var ThisMonth: UIImageView!
    @IBOutlet weak var blueView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currentStreak.layer.cornerRadius = 20
        currentStreak.layer.masksToBounds = true
        
        
        NeedsAttention.layer.cornerRadius = 20
        NeedsAttention.layer.masksToBounds = true
        
        ThisMonth.layer.cornerRadius = 20
        ThisMonth.layer.masksToBounds = true
        
        blueView.layer.cornerRadius = 16
        blueView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
        ThisMonth.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarTapped))
            ThisMonth.addGestureRecognizer(tapGesture)
    }
    @objc private func calendarTapped() {
        let calendarVC = CalendarViewController()

        let navVC = UINavigationController(rootViewController: calendarVC)
        navVC.modalPresentationStyle = .pageSheet

        // Optional: nice iOS sheet behavior
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        present(navVC, animated: true)
    }

}
