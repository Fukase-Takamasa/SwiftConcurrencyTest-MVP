//
//  FavoriteArticleListPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 14/7/22.
//

import Foundation
import Combine

protocol FavoriteArticleListPresentation: AnyObject {
    func viewDidLoad()
    func favoriteButtonTapped(article: ArticleEntity)
    func tableViewCellTapped(article: ArticleEntity)
}

@MainActor
class FavoriteArticleListPresenter {
    private weak var view: FavoriteArticleListView?
    private let router: FavoriteArticleListWireframe
    private let articleInteractor: ArticleUsecase
    
    private var cancellables = [AnyCancellable]()
    
    init(view: FavoriteArticleListView,
         router: FavoriteArticleListWireframe,
         articleInteractor: ArticleUsecase) {
        self.view = view
        self.router = router
        self.articleInteractor = articleInteractor
    }
    
}

extension FavoriteArticleListPresenter: FavoriteArticleListPresentation {
    func viewDidLoad() {
        //Storeからお気に入り記事一覧と全記事のLGTMリストモデルの値を結合して購読
        Publishers.CombineLatest(
            Store.shard.favoriteArticleList,
            Store.shard.lgtmUsersModelsResponse
        )
        .sink { (favoriteArticleList, lgtmUsersModelsResponse) in
            //値を受け渡して表示させる
            self.view?.showArticlesAndLgtmUsers(articles: favoriteArticleList, lgtmUsersModels: lgtmUsersModelsResponse ?? [])
        }.store(in: &cancellables)
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
