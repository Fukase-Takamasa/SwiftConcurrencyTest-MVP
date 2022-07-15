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

protocol MainTabBarView: AnyObject {
//    func updateUserIcon()
}

class MainTabBarController: UITabBarController {
    var presenter: MainTabBarPresentation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewDidLoad()

//        setUserIconButton()
    }
    
//    private func setUserIconButton() {
//        let userIconButton = UIButton(frame: CGRect(x: .zero, y: .zero, width: 40, height: 40))
//        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular, scale: .default)
//        let placeHolderImage = UIImage(systemName: "person.crop.circle", withConfiguration: systemImageConfig)
//
//        userIconButton.imageView?.tintColor = .lightGray
//        userIconButton.imageView?.cornerRadius = 20
//        userIconButton.setImage(placeHolderImage, for: .normal)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userIconButton)
//
//        Task {
//            try await userIconButton.kf
//                .setImage(with: URL(string: AuthorizedUserInterector.getAuthorizedUser()?.profileImageUrl ?? ""), for: .normal, placeholder: placeHolderImage)
//        }
//    }
    
}

extension MainTabBarController: MainTabBarView {
//    func updateUserIcon() {
//
//    }
}
