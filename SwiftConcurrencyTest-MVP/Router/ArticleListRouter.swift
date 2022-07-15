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

class ArticleListRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // - DI
    static func assembleModules() -> UIViewController {
        let view = ArticleListViewController.instantiate()
        let router = ArticleListRouter(viewController: view)
        let interector = ArticleInterector()
        let presenter = ArticleListPresenter(view: view, router: router, articleInterector: interector)
        
        view.presenter = presenter
        return view
    }
}

extension ArticleListRouter: ArticleListWireframe {
    func showArticleDetail(_ article: ArticleEntity) {
        
    }
}
