//
//  UserEntity.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation

struct UserEntity: Codable {
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
