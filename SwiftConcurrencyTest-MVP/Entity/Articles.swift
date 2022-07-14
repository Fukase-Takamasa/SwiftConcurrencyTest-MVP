//
//  Articles.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation

struct Article: Codable {
    let id: String
    let title: String
    let url: String
    let user: User
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case user
        case likesCount = "likes_count"
    }
}

struct User: Codable {
    let name: String?
    let id: String?
    let description: String?
    let location: String?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case description
        case location
        case profileImageUrl = "profile_image_url"
    }
}

struct LGTM: Codable {
    let createdAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case user
    }
}
