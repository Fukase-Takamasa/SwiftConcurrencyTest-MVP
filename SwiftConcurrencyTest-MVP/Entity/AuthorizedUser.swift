//
//  AuthorizedUser.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 12/7/22.
//

import Foundation

struct AuthorizedUser: Codable {
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
