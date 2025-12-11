//
//  User.swift
//  garden_app
//
//  Created by SDC-USER on 24/11/25.
//

import Foundation

class User: Codable {
    let id: String
    let name: String            // "Vedant Arya"
    let username: String        // "vedantarya.22" (No @ symbol here, we add it later)
    var profileImageString: String
    
    // Stats for Profile Page
    let plantCount: Int
    let friendCount: Int
    var personality: String?
    
    // Relationship status (For that "Add to Friends" button)
    var isFriend: Bool
    
    init(id: String, name: String, username: String, profileImageString: String, plantCount: Int, friendCount: Int, isFriend: Bool = false) {
        self.id = id
        self.name = name
        self.username = username
        self.profileImageString = profileImageString
        self.plantCount = plantCount
        self.friendCount = friendCount
        self.isFriend = isFriend
    }
    
    // Helper for Profile Page Label ("@vedantarya.22")
    var handle: String {
        return "@\(username)"
    }
    
    // Helper for Search Page ("12 Plants | 5 Friends")
    var searchSubtitle: String {
        return "\(plantCount) Plants | \(friendCount) Friends"
    }
}
