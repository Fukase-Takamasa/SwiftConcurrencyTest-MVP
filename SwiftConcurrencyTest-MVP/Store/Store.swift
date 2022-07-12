//
//  Store.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine

class Store {
    static var shard = Store()
    
    var authorizedUserResponse: AnyPublisher<User?, Never> {
        return authorizedUserResponseSubject.eraseToAnyPublisher()
    }

    var articlesResponse: AnyPublisher<[Article]?, Never> {
        return articlesResponseSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    var authorizedUserResponseSubject = CurrentValueSubject<User?, Never>(nil)
    var articlesResponseSubject = CurrentValueSubject<[Article]?, Never>(nil)
    var errorSubject = PassthroughSubject<Error, Never>()
}
