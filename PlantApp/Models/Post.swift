//
//  Post.swift
//  garden_app
//
//  Created by SDC-USER on 24/11/25.
//

import Foundation

// 1. Simplified Comment
struct Comment: Codable, Identifiable {
    let id: UUID
    let username: String
    let text: String
    let timeAgo: String
}

// 2. Post Structure
struct Post: Codable {
    let id: String
    let userId: String
    let postImageString: String
    var likesCount: Int
    let caption: String
    let timestamp: Date
    
    var author: User?
    var isLiked: Bool = false
    
    // List of comments for this post
    var comments: [Comment] = []
}
