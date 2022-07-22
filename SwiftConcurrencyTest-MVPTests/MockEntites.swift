//
//  MockEntites.swift
//  SwiftConcurrencyTest-MVPTests
//
//  Created by ウルトラ深瀬 on 22/7/22.
//

import Foundation
@testable import SwiftConcurrencyTest_MVP

class MockEntites {
    static let userEntityMock = UserEntity(
        name: "testName",
        id: "testId",
        description: "testDescription",
        location: "testLocation",
        profileImageUrl: "testUrl"
    )
    
    static let articleEntityMock = ArticleEntity(
        id: "testId",
        title: "testTitle",
        url: "testUrl",
        user: userEntityMock,
        likesCount: 0
    )
    
    static let lgtmEntityMock = LgtmEntity(
        createdAt: "testCreatedAt",
        user: userEntityMock
    )
}
