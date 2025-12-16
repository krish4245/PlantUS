//
//  Plant(dummy).swift
//  PlantApp
//
//  Created by SDC-USER on 12/12/25.
//
import Foundation
struct Plant_2: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var siteID: UUID
    var imageData: Data?
    var lightRequirement: String?
    var watering: String?
    var repotting: String?
    var quantity: Int? // number of plants added
}
