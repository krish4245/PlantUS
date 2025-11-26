//
//  Plant.swift
//  PlantApp
//
//  Created by SDC-USER on 24/11/25.
//

import Foundation
enum CareType{
    case watering
    case trimming
}


struct Plant {
    let name: String
    let subtitle: String
    let imageName: String
    let careType: CareType
}
