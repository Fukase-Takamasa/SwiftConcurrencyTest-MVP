//
//  MainTabBarController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 8/7/22.
//

import UIKit
import Combine
import CombineCocoa
import Kingfisher
import Alamofire

class MainTabBarController: UITabBarController {
    
    var firstVC: UIViewController?
    var secondVC: UIViewController?
    private var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserIconButton()

        var vcs: [UIViewController] = []
        
        firstVC = ArticleListViewController.instantiate()
        secondVC = FavoriteArticleListViewController.instantiate()
        
        guard let firstVC = firstVC, let secondVC = secondVC else {return}
        
        firstVC.tabBarItem = UITabBarItem(title: "一覧", image: UIImage(systemName: "newspaper"), tag: 0)
        
        secondVC.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "heart"), tag: 1)
        
        self.tabBar.tintColor = .black
        
        vcs.append(firstVC)
        vcs.append(secondVC)
        
        self.viewControllers = vcs.map{UINavigationController(rootViewController: $0)}
        self.setViewControllers(vcs, animated: false)
    }
    
    private func setUserIconButton() {
        let userIconButton = UIButton(frame: CGRect(x: .zero, y: .zero, width: 40, height: 40))
        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular, scale: .default)
        let placeHolderImage = UIImage(systemName: "person.crop.circle", withConfiguration: systemImageConfig)
        
        userIconButton.imageView?.tintColor = .lightGray
        userIconButton.imageView?.cornerRadius = 20
        userIconButton.setImage(placeHolderImage, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userIconButton)
        
        Task {
//            try await userIconButton.kf
//                .setImage(with: URL(string: AuthorizedUserInterector.getAuthorizedUser()?.profileImageUrl ?? ""), for: .normal, placeholder: placeHolderImage)
        }
    }
    
}
