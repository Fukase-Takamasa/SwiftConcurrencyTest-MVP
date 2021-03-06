//
//  ArticleListPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation

protocol ArticleListPresentation: AnyObject {
    func viewDidLoad()
    func favoriteButtonTapped(article: ArticleEntity)
    func tableViewCellTapped(article: ArticleEntity)
}

@MainActor
class ArticleListPresenter {
    private weak var view: ArticleListView?
    private let router: ArticleListWireframe
    private let articleInteractor: ArticleUsecase
    private let lgtmInteractor: LgtmUsecase
        
    init(view: ArticleListView,
         router: ArticleListWireframe,
         articleInteractor: ArticleUsecase,
         lgtmInteractor: LgtmUsecase
    ) {
        self.view = view
        self.router = router
        self.articleInteractor = articleInteractor
        self.lgtmInteractor = lgtmInteractor
    }
}

extension ArticleListPresenter: ArticleListPresentation {
    func viewDidLoad() {
        Task {
            //インジケータ表示
            self.view?.handleLoadingIndicator(isFetching: true)

            //iOSの人気記事一覧の取得を依頼
            let articles = try await self.articleInteractor.getPopularIosArticles()

            guard let articles = articles else { return }

            //viewに成功レスポンスを受け渡して表示させる
            self.view?.showArticles(articles: articles)

            //インジケータ非表示
            self.view?.handleLoadingIndicator(isFetching: false)

            //取得した各記事のLGTMユーザーリストを非同期で並行取得依頼
            let lgtmUsersModels = try await self.lgtmInteractor.getLgtmUsersOfEachArticles(articles: articles)

            guard let lgtmUsersModels = lgtmUsersModels else { return }

            //成功レスポンスを受け渡して処理をさせる
            self.view?.showLgtmUsersOfEachArticles(lgtmUsersModels: lgtmUsersModels)
        }
    }
    
    func favoriteButtonTapped(article: ArticleEntity) {
        //既にfavoriteArticleListに存在するかをチェック
        let isFavoriteArticle = ArticleListUtil.isFavoriteArticle(
            favoriteArticleList: Store.shard.favoriteArticleListSubject.value,
            article: article)
        
        if isFavoriteArticle {
            //既にListに存在するので削除
            articleInteractor.removeFavoriteArticle(article: article)
            
        }else {
            //まだListに存在しないので追加
            articleInteractor.addFavoriteArticle(article: article)
        }
        
        //ViewにtableViewの再描画をさせる
        view?.reloadTableView()
    }
    
    func tableViewCellTapped(article: ArticleEntity) {
        router.showArticleDetail(article)
    }
}
