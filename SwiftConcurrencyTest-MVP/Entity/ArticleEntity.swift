//
//  ArticleEntity.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation

struct ArticleEntity: Codable {
    let id: String
    let title: String
    let url: String
    let user: UserEntity
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case user
        case likesCount = "likes_count"
    }
}
