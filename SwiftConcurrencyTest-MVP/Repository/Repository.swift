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
    
    static func getAuthorizedUser() async throws {
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

    static func getMonthlyPupularArticles() async throws {
        let parameters = [
            "created": "2022-07-12",
            "likes": ">10",
        ]
        let task = AF.request(QiitaAPI.getArticles(queryParameters: parameters)).serializingDecodable([Article].self)
        let response = await task.response
        switch (response.response?.statusCode ?? 0) {
            //200~299を正常系とみなし、それ以外はErrorをthrow
        case 200...299:
            let value = response.value
            print("getArticles success value: \(String(describing: value))")
            //成功レスポンスから取り出した値をStoreに格納
            store.articlesResponseSubject.send(value)
            
            //Alamofireのエラーがあれば返し、なければカスタムエラーを返す
        default:
            guard let afError = response.error else {
                print("getArticles unexpectedServerError")
                throw CustomError.unexpectedServerError
            }
            print("getArticles response error: \(afError)")
            throw afError
        }
    }
}
