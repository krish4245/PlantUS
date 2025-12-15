//
//  Comment.swift
//  garden_app
//
//  Created by SDC-USER on 08/12/25.
//


import Foundation

struct Comment: Codable {
    let id: String
    let userId: String
    let text: String
    let timestamp: Date
    
    // For "View 1 more reply" (Threading)
    let replyCount: Int 
    
    // We link the user manually
    var user: User?
}