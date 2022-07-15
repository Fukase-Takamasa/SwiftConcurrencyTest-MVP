//
//  ArticleListPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine

protocol ArticleListPresentation: AnyObject {
    func monthlyPopularArticlesResponse(articles: [ArticleEntity])
    func lgtmUsersOfEachArticlesResponse(lgtmUsersModelsOfEachArticles: [LgtmUsersModel])
    func errorResponse(error: Error)
    func isFetching(_ flag : Bool)
}

class ArticleListPresenter {
//    private weak var listener: ArticleListPresentation?
    private weak var view: ArticleListView?
    private let router: ArticleListWireframe
    private let articleInterector: ArticleUsecase
    
    private var cancellables = [AnyCancellable]()
        
    //MARK: - output（PresenterからListenerの処理を呼び出す）
    //このPresenterのインターフェースに準拠した抽象的なListener（VC）を注入する
//    init(listener: ArticleListPresentation) {
//        self.listener = listener
//    }
    init(view: ArticleListView,
         router: ArticleListWireframe,
         articleInterector: ArticleUsecase) {
        self.view = view
        self.router = router
        self.articleInterector = articleInterector
    }
    
    //MARK: - input（ListenerからPresenterの処理を呼び出す）
//    func getMonthlyPupularArticles() {
        //インジケータ表示
//        listener?.isFetching(true)
        
        //API叩く（結果はStoreに格納される）
//        Task {
//            let articles = try await ArticleInterector.getPopularIosArticles()
//
//            guard let articles = articles else { return }
//
//            //成功レスポンスを受け渡して処理をさせる
//            listener?.monthlyPopularArticlesResponse(articles: articles)
//
//            //インジケータ非表示
//            listener?.isFetching(false)
//
//            //取得した各記事のLGTMユーザーリストを非同期で並行取得する
//            print("=== getLgtmUsersOfEachArticles開始 ===")
//
//            let lgtmUsersModelsOfEachArticles = try await LgtmInterector.getLgtmUsersOfEachArticles(articles: articles)
//
//            print("lgtmUsersModelsOfEachArticles: \(lgtmUsersModelsOfEachArticles)")
//            print("=== getLgtmUsersOfEachArticles完了 ===")
//
//            //成功レスポンスを受け渡して処理をさせる
//            listener?.lgtmUsersOfEachArticlesResponse(lgtmUsersModelsOfEachArticles: lgtmUsersModelsOfEachArticles)
//        }
//    }
}

extension ArticleListPresenter: ArticleListPresentation {
    func monthlyPopularArticlesResponse(articles: [ArticleEntity]) {
        
    }

    func lgtmUsersOfEachArticlesResponse(lgtmUsersModelsOfEachArticles: [LgtmUsersModel]) {
        
    }

    func errorResponse(error: Error) {
        
    }

    func isFetching(_ flag: Bool) {
        
    }
}
