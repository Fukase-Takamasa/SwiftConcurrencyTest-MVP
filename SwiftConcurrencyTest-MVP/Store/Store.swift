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
    
    var authorizedUserResponse: AnyPublisher<UserEntity?, Never> {
        return authorizedUserResponseSubject.eraseToAnyPublisher()
    }

    var popularIosArticlesResponse: AnyPublisher<[ArticleEntity]?, Never> {
        return popularIosArticlesResponseSubject.eraseToAnyPublisher()
    }
    
    var lgtmUsersModelsResponse: AnyPublisher<[LgtmUsersModel]?, Never> {
        return lgtmUsersModelsResponseSubject.eraseToAnyPublisher()
    }
    
    var favoriteArticleList: AnyPublisher<[ArticleEntity], Never> {
        return favoriteArticleListSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    var authorizedUserResponseSubject = CurrentValueSubject<UserEntity?, Never>(nil)
    var popularIosArticlesResponseSubject = CurrentValueSubject<[ArticleEntity]?, Never>(nil)
    var lgtmUsersModelsResponseSubject = CurrentValueSubject<[LgtmUsersModel]?, Never>(nil)
    var favoriteArticleListSubject = CurrentValueSubject<[ArticleEntity], Never>([])
    var errorSubject = PassthroughSubject<Error, Never>()
}
