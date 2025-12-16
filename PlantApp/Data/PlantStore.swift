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
    
    
    // MARK: Generate Dummy Plants for testing
    func generateDummyPlants(for sites: [MyGardenSite]) {
        guard plants.isEmpty else { return }  // prevents duplicating dummy data

        let names = ["Jade Plant", "Money Plant", "Snake Plant", "Areca Palm"]
        let light = ["Medium Light", "Low Light", "Bright Light", "Medium Light"]
        let water = ["2 days ago", "yesterday", "4 days ago", "1 week ago"]
        let repot = "Every 6 months"
        let imageNames = ["dummy1", "dummy2", "dummy3", "dummy4"]

        // Loop through sites, and assign 1 dummy plant to each site
        for (index, site) in sites.enumerated() {
            let i = index % names.count   // safe indexing even if more sites exist

            let dummy = Plant_2(
                id: UUID(),
                name: names[i],
                siteID: site.id,    // 🔥 Link dummy plant to each site
                imageData: UIImage(named: imageNames[i])?.jpegData(compressionQuality: 0.8),
                lightRequirement: light[i],
                watering: water[i],
                repotting: repot,
                quantity: 1
            )

            plants.append(dummy)
        }

        savePlants()
    }

    @Published var plants: [Plant_2] = [] {
        didSet { savePlants() }
    }

    private let key = "savedPlants"

    private init() {
        loadPlants()
    }

    // MARK: Add a new plant
    func addPlant(_ plant: Plant_2) {
        plants.append(plant)
    }

    // MARK: Get plants for a specific site
    func plants(for siteID: UUID) -> [Plant_2] {
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
           let decoded = try? JSONDecoder().decode([Plant_2].self, from: data) {
            plants = decoded
        }
    }
}
