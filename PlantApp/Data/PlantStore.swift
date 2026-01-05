//
//  PlantStore.swift
//  PlantApp
//
//  Created by SDC-USER on 12/12/25.
//

import Foundation
internal import Combine
import UIKit

class PlantStore: ObservableObject {
    
    static let shared = PlantStore()
    
    


    @Published private(set) var plants: [UserPlant] = [] {
        didSet { savePlants() }
    }


    private let key = "savedPlants"

    private init() {
        loadPlants()
    }

    // MARK: Add a new plant
    func addPlant(_ plant: UserPlant) {
        plants.append(plant)
    }

    // MARK: Get plants for a specific site
    func plants(for siteID: UUID) -> [UserPlant] {
        return plants.filter { $0.siteID == siteID }
    }

    // MARK: Save
    private func savePlants() {
        if let encoded = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // MARK: Load
    private func loadPlants() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([UserPlant].self, from: data) {
            plants = decoded
        }
    }
}

extension PlantDataSource {

    func plant(for id: String) -> PlantModel_Ved? {
        return plants.first { $0.id == id }
    }
}

extension PlantStore {

    func hasUserAddedPlant(plantId: String) -> Bool {
        return plants.contains { $0.plantId == plantId }
    }
}

