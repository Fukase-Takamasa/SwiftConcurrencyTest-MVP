//
//  Articles.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation

struct Article: Codable {
    var title: String
    var user: User
}

struct User: Codable {
    var name: String
    var id: String
    var description: String
    var location: String
    var profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case description
        case location
        case profileImageUrl = "profile_image_url"
    }
}
