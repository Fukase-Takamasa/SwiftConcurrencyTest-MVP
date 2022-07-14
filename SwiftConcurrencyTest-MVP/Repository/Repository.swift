//
//  Repository.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine
import Alamofire

@MainActor
final class Repository {
    private static let store = Store.shard
    
    static func getAuthorizedUser() async throws -> User? {
        let task = AF.request(QiitaAPI.getAuthorizedUser).serializingDecodable(User.self)
        let response = await task.response
        print("statusCode: \(response.response?.statusCode ?? 0)")
        switch (response.response?.statusCode ?? 0) {
            //200~299を正常系とみなし、それ以外はErrorをthrow
        case 200...299:
            let value = response.value
            print("getAuthorizedUser success value: \(String(describing: value))")
            //成功レスポンスから取り出した値をStoreに格納
            store.authorizedUserResponseSubject.send(value)
            
            //呼び出し元にも値を返却
            return value
            
            //Alamofireのエラーがあれば返し、なければカスタムエラーを返す
        default:
            guard let afError = response.error else {
                print("getAuthorizedUser unexpectedServerError")
                throw CustomError.unexpectedServerError
            }
            print("getAuthorizedUser response error: \(afError)")
            throw afError
        }
    }

    static func getPopularIosArticles() async throws -> [Article]? {
        let parameters: Parameters = [
            "page": "1",
            "per_page": "10",
            "query": "tag:iOS created:>2017-01-01 stocks:>100"
        ]
        
        let task = AF.request(QiitaAPI.getArticles(queryParameters: parameters)).serializingDecodable([Article].self)
        let response = await task.response

        switch (response.response?.statusCode ?? 0) {
            //200~299を正常系とみなし、それ以外はErrorをthrow
        case 200...299:
            let value = response.value
            print("getPopularIosArticles success value: \(String(describing: value))")
            //成功レスポンスから取り出した値をStoreに格納
            store.popularIosArticlesResponseSubject.send(value)
            
            //呼び出し元にも値を返却
            return value
            
            //Alamofireのエラーがあれば返し、なければカスタムエラーを返す
        default:
            guard let afError = response.error else {
                print("getPopularIosArticles unexpectedServerError")
                throw CustomError.unexpectedServerError
            }
            print("getPopularIosArticles response error: \(afError)")
            throw afError
        }
    }
    
    static func getLgtmUsers(articleId: String) async throws -> [LGTM]? {
        let parameters: Parameters = [
            "page": "1",
            "per_page": "10",
        ]
        
        let task = AF.request(QiitaAPI.getLgtmUsers(articleId: articleId, queryParameters: parameters)).serializingDecodable([LGTM].self)
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
    static func getLgtmUsersOfEachArticles(articles: [Article]) async throws -> [LgtmUsersModel] {
        try await withThrowingTaskGroup(of: (LgtmUsersModel).self, body: { group in
            for (articleId, likesCount) in articles.map({ ($0.id, $0.likesCount) }) {
                group.addTask {
                    let lgtmUsers = try await getLgtmUsers(articleId: articleId) ?? []
                    //必要なキーを足した独自のModel構造体に差し替えて返却
                    return LgtmUsersModel(articleId: articleId,
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
