//
//  PlantModel_Ved.swift
//  PlantApp
//
//  Created by vedant on 30/12/25.
//

import Foundation

enum CareDifficulty: String, Codable {
    case easy
    case moderate
    case hard
}

struct PlantModel_Ved: Identifiable, Codable {
    
    // GLOBAL ID (used everywhere)
    let id: String          // UUID string or server ID
    
    // Core Identity
    let name: String
    let tagline: String?    // "Beginner Friendly"
    let description: String?
    
    //  Care Info (used in browse + garden)
    let careDifficulty: CareDifficulty
    let light: String?
    let water: String?
    let soil: String?
    
    // Image
    let imageName: String   // local asset or URL
   

    

}
