//
//  ArticleListRouter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import UIKit

protocol ArticleListWireframe: AnyObject {
    func showArticleDetail(_ article: ArticleEntity)
}

@MainActor
class ArticleListRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // - DI
    static func assembleModules() -> UIViewController {
        let view = ArticleListViewController.instantiate()
        let router = ArticleListRouter(viewController: view)
        let articleInteractor = ArticleInteractor()
        let lgtmInteractor = LgtmInteractor()
        let presenter = ArticleListPresenter(
            view: view,
            router: router,
            articleInteractor: articleInteractor,
            lgtmInteractor: lgtmInteractor)
        
        view.presenter = presenter
        return view
    }
}

extension ArticleListRouter: ArticleListWireframe {
    func showArticleDetail(_ article: ArticleEntity) {
        let articleDetailVC = ArticleDetailRouter.assembleModules()
        articleDetailVC.article = article
        self.viewController.navigationController?.pushViewController(articleDetailVC, animated: true)
    }
}
