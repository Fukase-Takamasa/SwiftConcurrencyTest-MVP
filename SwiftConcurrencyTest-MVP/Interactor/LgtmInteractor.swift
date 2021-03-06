//
//  LgtmInteractor.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation
import Combine
import Alamofire

protocol LgtmUsecase: AnyObject {
    func getLgtmUsers(articleId: String) async throws -> [LgtmEntity]?
    func getLgtmUsersOfEachArticles(articles: [ArticleEntity]) async throws -> [LgtmUsersModel]?
}

final class LgtmInteractor: LgtmUsecase {
    private let store = Store.shard
    
    func getLgtmUsers(articleId: String) async throws -> [LgtmEntity]? {
        let parameters: Parameters = [
            "page": "1",
            "per_page": "10",
        ]
        
        let task = AF.request(QiitaAPI.getLgtmUsers(articleId: articleId, queryParameters: parameters)).serializingDecodable([LgtmEntity].self)
        let response = await task.response
        print("statusCode: \(response.response?.statusCode ?? 0)")
        switch (response.response?.statusCode ?? 0) {
            //200~299を正常系とみなし、それ以外はErrorをthrow
        case 200...299:
            let value = response.value
            print("getLgtmUsers success value: \(String(describing: value))")
            //呼び出し元に値を返却
            return value
            
            //Alamofireのエラーがあれば返し、なければカスタムエラーを返す
        default:
            guard let afError = response.error else {
                print("getLgtmUsers unexpectedServerError")
                throw CustomError.unexpectedServerError
            }
            print("getLgtmUsers response error: \(afError)")
            throw afError
        }
    }
    
    //一覧記事それぞれに紐づくLGTMユーザーリストを並行取得する（可変個数TaskでのTask.group並行処理）
    func getLgtmUsersOfEachArticles(articles: [ArticleEntity]) async throws -> [LgtmUsersModel]? {
        try await withThrowingTaskGroup(of: (LgtmUsersModel).self, body: { group in
            for (articleId, likesCount) in articles.map({ ($0.id, $0.likesCount) }) {
                group.addTask {
                    let lgtmUsers = try await self.getLgtmUsers(articleId: articleId) ?? []
                    //必要なキーを足した独自のModel構造体に差し替えて返却
                    return LgtmUsersModel(
                        articleId: articleId,
                        totalLgtmCount: likesCount,
                        lgtms: lgtmUsers)
                }
            }
            var lgtmUsersModels = [LgtmUsersModel]()
            for try await taskResult in group {
                lgtmUsersModels.append(taskResult)
            }

            //成功レスポンスから取り出した値をStoreに格納
            store.lgtmUsersModelsResponseSubject.send(lgtmUsersModels)

            //呼び出し元にも値を返却
            return lgtmUsersModels
        })
    }
}
