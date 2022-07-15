//
//  AuthorizedUserInterector.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine
import Alamofire

@MainActor
final class AuthorizedUserInterector {
    private static let store = Store.shard
    
    static func getAuthorizedUser() async throws -> UserEntity? {
        let task = AF.request(QiitaAPI.getAuthorizedUser).serializingDecodable(UserEntity.self)
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
}
