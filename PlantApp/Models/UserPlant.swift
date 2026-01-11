//
//  Plant(dummy).swift
//  PlantApp
//
//  Created by SDC-USER on 12/12/25.
//
import Foundation
struct UserPlant: Identifiable, Codable {
    let id: UUID = UUID() 
    let plantId: String
    var siteName: String
    let  siteID: UUID
    var imageData: Data?
    var lightRequirement: String?
    let watering: String?
    let repotting: String?
    var quantity: Int = 1 // number of plants added
    
    
    // Garden-only (mutable, user specific)
    var isAddedToGarden: Bool
    var wateringDone: Bool
    var trimmingDone: Bool
    var fertilizingDone: Bool
    
    //date created at
    let createdAt: Date
}
