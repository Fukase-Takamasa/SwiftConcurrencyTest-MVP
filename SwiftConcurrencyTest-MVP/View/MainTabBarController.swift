//
//  MainTabBarController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 8/7/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var firstVC: UIViewController?
    var secondVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        var vcs: [UIViewController] = []
        
        firstVC = ArticleListViewController.instantiate()
        secondVC = ArticleListViewController.instantiate()
        
        guard let firstVC = firstVC, let secondVC = secondVC else {return}
        
        firstVC.tabBarItem = UITabBarItem(title: "一覧", image: UIImage(systemName: "news"), tag: 0)
        
        secondVC.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "heart"), tag: 1)
        
        vcs.append(firstVC)
        vcs.append(secondVC)
        
        self.viewControllers = vcs.map{UINavigationController(rootViewController: $0)}
        self.setViewControllers(vcs, animated: false)
    }
    
}
