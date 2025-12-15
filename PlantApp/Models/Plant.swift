//
//  Plant.swift
//  PlantApp
//
//  Created by SDC-USER on 24/11/25.
//

import Foundation

enum CareType: Int {
    case watering = 0
    case trimming = 1
    case repotting = 2
    case fertilising = 3
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
}
