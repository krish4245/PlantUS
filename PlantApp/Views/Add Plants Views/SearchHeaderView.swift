//
//  SearchHeaderView.swift
//  PlantApp
//
//  Created by SDC-USER on 08/12/25.
//

import Foundation
import UIKit

protocol SearchHeaderViewDelegate: AnyObject {
    func searchHeaderDidTapMenu(_ header: SearchHeaderView)
}

class SearchHeaderView: UICollectionReusableView {
    @IBOutlet weak var menuButton: UIButton!    // connect to 3-dots in storyboard
    weak var delegate: SearchHeaderViewDelegate?

    @IBAction func menuButtonTapped(_ sender: UIButton) {
        delegate?.searchHeaderDidTapMenu(self)
    }
}
