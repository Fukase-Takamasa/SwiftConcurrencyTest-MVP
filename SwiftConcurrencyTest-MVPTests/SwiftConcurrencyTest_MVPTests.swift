//
//  SwiftConcurrencyTest_MVPTests.swift
//  SwiftConcurrencyTest-MVPTests
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import XCTest
import Combine
@testable import SwiftConcurrencyTest_MVP

class SwiftConcurrencyTest_MVPTests: XCTestCase {

    func test_addFavoriteArticle() {
        let mockUserEntity = UserEntity(
            name: "testName",
            id: "testId",
            description: "testDescription",
            location: "testLocation",
            profileImageUrl: "testUrl")
        
        let mockArticleEntity = ArticleEntity(
            id: "testId",
            title: "testTitle",
            url: "testUrl",
            user: mockUserEntity,
            likesCount: 0)
        
        let mockStoreFavoriteArticleListSubject = CurrentValueSubject<[ArticleEntity], Never>([])
        
        let result1 = mockStoreFavoriteArticleListSubject.value.contains(where: { item in
            item.id == mockArticleEntity.id
        })
        
        XCTAssertEqual(false, result1)
        
        //現在のstoreValueにタップしたセルのarticleを追加したリストを流す
        mockStoreFavoriteArticleListSubject.send(
            mockStoreFavoriteArticleListSubject.value + [mockArticleEntity]
        )
        
        let result2 = mockStoreFavoriteArticleListSubject.value.contains(where: { item in
            item.id == mockArticleEntity.id
        })
        
        XCTAssertEqual(true, result2)
        
        //現在のstoreValueからタップしたセルのarticleを削除したリストを流す
        mockStoreFavoriteArticleListSubject.send(
            mockStoreFavoriteArticleListSubject.value.filter({ item in
                item.id != mockArticleEntity.id
            })
        )
        
        let result3 = mockStoreFavoriteArticleListSubject.value.contains(where: { item in
            item.id == mockArticleEntity.id
        })
        
        XCTAssertEqual(false, result3)
    }
    
}
