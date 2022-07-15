//
//  LgtmEntity.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation

struct LgtmEntity: Codable {
    let createdAt: String
    let user: UserEntity
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case user
    }
}
