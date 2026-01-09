//
//  Plant.swift
//  PlantApp
//
//  Created by SDC-USER on 24/11/25.
//

import Foundation
import UIKit

enum CareType: Int {
    case watering = 0
    case trimming = 1
    case repotting = 2
    case fertilizing = 3
}

struct Plant {
    let id: String = UUID().uuidString
    let name: String
    let subtitle: String
    let imageName: String
    let careType: CareType
    var wateringDone: Bool = false
    var sunlightDone: Bool = false
    var fertilizingDone: Bool = false
//    let space: String
}
extension CareType {

    var displayName: String {
        switch self {
        case .watering:
            return "Watering"
        case .trimming:
            return "Pruning"
        case .repotting:
            return "Repotting"
        case .fertilizing:
            return "Fertilizing"
        }
    }

    var icon: UIImage? {
        switch self {
        case .watering:
            return UIImage(systemName: "drop.fill")
        case .trimming:
            return UIImage(systemName: "scissors")
        case .repotting:
            return UIImage(systemName: "arrow.triangle.2.circlepath")
        case .fertilizing:
            return UIImage(systemName: "leaf.fill")
        }
    }
}
