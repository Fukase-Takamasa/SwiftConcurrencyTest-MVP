//
//  MainTabBarRouter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import UIKit

protocol MainTabBarWireframe: AnyObject {
    func setupViewControllers()
}

@MainActor
class MainTabBarRouter {
    private unowned let tabBarViewController: UITabBarController
    
    private init(tabBarViewController: UITabBarController) {
        self.tabBarViewController = tabBarViewController
    }
    
    // - DI
    static func assembleModules() -> UITabBarController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainTabBarController
        let router = MainTabBarRouter(tabBarViewController: view)
        let interector = AuthorizedUserInterector()
        let presenter = MainTabBarPresenter(view: view, router: router, authorizedUserInterector: interector)
        
        view.presenter = presenter
        return view
    }
}

extension MainTabBarRouter: MainTabBarWireframe {
    func setupViewControllers() {
        var vcs: [UIViewController] = []
        
        let articleListVC = ArticleListRouter.assembleModules()
        let favoriteArticleListVC = FavoriteArticleListRouter.assembleModules()
        
        articleListVC.tabBarItem = UITabBarItem(title: "一覧", image: UIImage(systemName: "newspaper"), tag: 0)
        favoriteArticleListVC.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "heart"), tag: 1)
        
        self.tabBarViewController.tabBar.tintColor = .black
        
        vcs.append(articleListVC)
        vcs.append(favoriteArticleListVC)
        
        self.tabBarViewController.viewControllers = vcs.map{UINavigationController(rootViewController: $0)}
        self.tabBarViewController.setViewControllers(vcs, animated: false)
    }
}

