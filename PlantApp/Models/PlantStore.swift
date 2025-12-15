//
//  PlantStore.swift
//  PlantApp
//
//  Created by SDC-USER on 12/12/25.
//


import Foundation

class PlantStore {
    static let shared = PlantStore()

    private init() {}

    // User's real plants (initially empty)
    var plants: [PlantModel] = []

    // Spaces (initially empty)
    var spaces: Int {
        return 0 // until you add a real feature
    }

    var totalPlants: Int {
        return plants.count
    }
}
