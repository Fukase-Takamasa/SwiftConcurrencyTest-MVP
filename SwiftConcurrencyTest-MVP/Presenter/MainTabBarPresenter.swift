//
//  MainTabBarPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation
import Combine

protocol MainTabBarPresentation: AnyObject {
    func viewDidLoad()
}

class MainTabBarPresenter {
//    private weak var listener: FavoriteArticleListPresenterInterface?
    private weak var view: MainTabBarView?
    private let router: MainTabBarWireframe
    private let authorizedUserInterector: AuthorizedUserUsecase
    
    private var cancellables = [AnyCancellable]()
    
    //MARK: - output（PresenterからListenerの処理を呼び出す）
    //このPresenterのインターフェースに準拠した抽象的なListener（VC）を注入する
//    init(listener: FavoriteArticleListPresenterInterface) {
//        self.listener = listener
//
//        Publishers.CombineLatest(
//            Store.shard.favoriteArticleList,
//            Store.shard.lgtmUsersModelsResponse
//        )
//        .sink { (favoriteArticleList, lgtmUsersModelsResponse) in
//            listener.showFavoriteArticles(articles: favoriteArticleList,
//                                          lgtmUsersModelsOfEachArticles: lgtmUsersModelsResponse ?? [])
//        }.store(in: &cancellables)
//    }
    
    init(view: MainTabBarView,
         router: MainTabBarWireframe,
         authorizedUserInterector: AuthorizedUserUsecase) {
        self.view = view
        self.router = router
        self.authorizedUserInterector = authorizedUserInterector
    }
    
}

extension MainTabBarPresenter: MainTabBarPresentation {
    func viewDidLoad() {
        self.router.setupViewControllers()
    }
}
