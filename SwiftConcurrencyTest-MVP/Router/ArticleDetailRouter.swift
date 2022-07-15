//
//  ArticleDetailRouter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import UIKit

protocol ArticleDetailWireframe: AnyObject {
//    func showArticleDetail(_ article: ArticleEntity)
}

@MainActor
class ArticleDetailRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // - DI
    static func assembleModules() -> UIViewController {
        let view = ArticleDetailViewController.instantiate()
        let router = ArticleDetailRouter(viewController: view)
        let interector = ArticleInterector()
        let presenter = ArticleDetailPresenter(view: view, router: router, articleInterector: interector)
        
        view.presenter = presenter
        return view
    }
}

extension ArticleDetailRouter: ArticleDetailWireframe {
//    func showArticleDetail(_ article: ArticleEntity) {
//
//    }
}
