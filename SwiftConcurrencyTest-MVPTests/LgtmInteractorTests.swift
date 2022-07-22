//
//  LgtmInteractorTests.swift
//  SwiftConcurrencyTest-MVPTests
//
//  Created by ウルトラ深瀬 on 22/7/22.
//

@testable import SwiftConcurrencyTest_MVP
import XCTest
import Combine

class LgtmInteractorTests: XCTestCase {

    func test_１．５秒かかるTaskを10個並列実行して２．０秒以内に（誤差がプラス0．5秒以内）全て完了すれば成功() async throws {
        let lgtmInteractor = LgtmInteractor()
        
        let sleepDuration: UInt64 = 1_500_000_000

        //モックの記事リストを作成
        let mockArticles = [
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock,
            MockEntites.articleEntityMock
        ]
        
        //記事に紐づくLGTMリストを取得するメソッドのモックを作成（1.5秒後に固定にモックLgtmEntityリストを返す）
        func getLgtmUsersMock() async throws -> [LgtmEntity] {
            try await Task.sleep(nanoseconds: sleepDuration)
            return [
                MockEntites.lgtmEntityMock,
                MockEntites.lgtmEntityMock,
                MockEntites.lgtmEntityMock,
            ]
        }

        let start = Date()
        let result: [LgtmUsersModel]? = try await lgtmInteractor.getLgtmUsersOfEachArticles(
            articles: mockArticles,
            getLgtmUsers: { articleId in
                //モックリクエストを渡す
                try await getLgtmUsersMock()
            })
        print("result: \(String(describing: result))")
        
        let elapsed = Date().timeIntervalSince(start)
        print("実行時間: \(elapsed)")
        
        //実行時間と2.0秒の差が0.5以内かどうかチェック
        XCTAssertEqual(Float(elapsed), 2.0, accuracy: 0.5)

    }

}
