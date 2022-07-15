//
//  ArticleInterector.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation
import Combine
import Alamofire

@MainActor
final class ArticleInterector {
    private static let store = Store.shard
    
    static func getPopularIosArticles() async throws -> [ArticleEntity]? {
        let parameters: Parameters = [
            "page": "1",
            "per_page": "10",
            "query": "tag:iOS created:>2017-01-01 stocks:>100"
        ]
        
        let task = AF.request(QiitaAPI.getArticles(queryParameters: parameters)).serializingDecodable([ArticleEntity].self)
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
}
