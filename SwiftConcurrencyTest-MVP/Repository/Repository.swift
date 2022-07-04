//
//  Repository.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine
import Alamofire

final class Repository {
    private static let store = Store.shard
    
    static func getArticles() {
        AF.request(QiitaAPI.articles)
            .responseDecodable(of: [Article].self) { response in
                print("requestUrl: \(String(describing: response.request?.url))")

                switch response.result {
                case .success(let value):
                    print("getArticles success value: \(value)")
                    store.articlesResponseSubject.send(value)
                    
                case .failure(let error):
                    print("getArticles failure error: \(error)")
                    store.errorSubject.send(error)
                }
            }
    }
    
}
