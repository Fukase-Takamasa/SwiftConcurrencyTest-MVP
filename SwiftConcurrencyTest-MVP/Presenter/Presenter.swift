//
//  Presenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine

protocol PresenterInterface: AnyObject {
    func authorizedUserResponse(user: User)
    func monthlyPopularArticlesResponse(articles: [Article])
    func errorResponse(error: Error)
    func isFetching(_ flag : Bool)
}

class Presenter {
    private weak var listener: PresenterInterface?
    private var cancellables = [AnyCancellable]()
    
    
    //MARK: - output（PresenterからListenerの処理を呼び出す）
    //このPresenterのインターフェースに準拠した抽象的なListener（VC）を注入する
    init(listener: PresenterInterface) {
        self.listener = listener
        
        //Storeに格納されたレスポンスを監視
        Store.shard.authorizedUserResponse
            .sink { element in
                print("presenter authorizedUserResponse: \(String(describing: element))")
                guard let user = element else { return }
                
                //成功レスポンスを受け渡して処理をさせる
                listener.authorizedUserResponse(user: user)
            }.store(in: &cancellables)
        
        Store.shard.articlesResponse
            .sink { element in
                print("presenter articlesResponse: \(String(describing: element))")
                guard let articles = element else { return }
                
                //成功レスポンスを受け渡して処理をさせる
                listener.monthlyPopularArticlesResponse(articles: articles)
                
                //インジケータ非表示
                listener.isFetching(false)
            }.store(in: &cancellables)
    }
    
    //MARK: - input（ListenerからPresenterの処理を呼び出す）
    func getAuthorizedUser() {
        //API叩く（結果はStoreに格納される）
        Task {
            try await Repository.getAuthorizedUser()
        }
    }
    
    func getMonthlyPupularArticles() {
        //インジケータ表示
        listener?.isFetching(true)
        
        //API叩く（結果はStoreに格納される）
        Task {
            try await Repository.getMonthlyPupularArticles()
        }
    }
}
