//
//  FavoriteArticleListRouter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import UIKit

protocol FavoriteArticleListWireframe: AnyObject {
    func showArticleDetail(_ article: ArticleEntity)
}

@MainActor
class FavoriteArticleListRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // - DI
    static func assembleModules() -> UIViewController {
        let view = FavoriteArticleListViewController.instantiate()
        let router = FavoriteArticleListRouter(viewController: view)
        let interactor = ArticleInteractor()
        let presenter = FavoriteArticleListPresenter(view: view, router: router, articleInteractor: interactor)
        
        view.presenter = presenter
        return view
    }
}

extension FavoriteArticleListRouter: FavoriteArticleListWireframe {
    func showArticleDetail(_ article: ArticleEntity) {
        let articleDetailVC = ArticleDetailRouter.assembleModules()
        articleDetailVC.article = article
        self.viewController.navigationController?.pushViewController(articleDetailVC, animated: true)
    }
}
