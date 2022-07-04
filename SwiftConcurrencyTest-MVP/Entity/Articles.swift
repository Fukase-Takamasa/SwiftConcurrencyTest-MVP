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
}
