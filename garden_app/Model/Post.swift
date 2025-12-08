//
//  Post.swift
//  garden_app
//
//  Created by SDC-USER on 24/11/25.
//

import Foundation

struct Post: Codable {
    let id: String
    let userId: String
    let postImageString: String
    let caption: String
    let timestamp: Date
    
    // We link the actual User object manually when fetching
    var author: User?
    
    // (New) Comments for the Comment Page
    // We store comment IDs here, or fetch them separately.
    // For now, let's keep it simple and just count them.
    var commentCount: Int = 0
}
