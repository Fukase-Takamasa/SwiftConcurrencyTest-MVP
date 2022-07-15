//
//  FavoriteArticleListRouter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import UIKit

protocol FavoriteArticleListWireframe {
//    func showArticleDetail(_ article: ArticleEntity)
}

class FavoriteArticleListRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // - DI
    static func assembleModules() -> UIViewController {
        let view = FavoriteArticleListViewController.instantiate()
        let router = FavoriteArticleListRouter(viewController: view)
        let interector = ArticleInterector()
        let presenter = FavoriteArticleListPresenter(view: view, router: router, articleInterector: interector)
        
        view.presenter = presenter
        return view
    }
}

extension FavoriteArticleListRouter: FavoriteArticleListWireframe {
//    func showArticleDetail(_ article: ArticleEntity) {
//
//    }
}