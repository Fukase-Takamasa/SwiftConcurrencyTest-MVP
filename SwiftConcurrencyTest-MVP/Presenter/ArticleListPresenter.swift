//
//  ArticleListPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine

protocol ArticleListPresenterInterface: AnyObject {
    func monthlyPopularArticlesResponse(articles: [Article])
    func errorResponse(error: Error)
    func isFetching(_ flag : Bool)
}

class ArticleListPresenter {
    private weak var listener: ArticleListPresenterInterface?
    private var cancellables = [AnyCancellable]()
    
    
    //MARK: - output（PresenterからListenerの処理を呼び出す）
    //このPresenterのインターフェースに準拠した抽象的なListener（VC）を注入する
    init(listener: ArticleListPresenterInterface) {
        self.listener = listener
        
        //Storeに格納されたレスポンスを監視
        Store.shard.popularIosArticlesResponseSubject
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
    func getMonthlyPupularArticles() {
        //インジケータ表示
        listener?.isFetching(true)
        
        //API叩く（結果はStoreに格納される）
        Task {
            try await Repository.getPopularIosArticles()
        }
    }
}
