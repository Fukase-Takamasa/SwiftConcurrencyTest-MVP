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
    func updateUserIcon(imageUrl: String)
}

class MainTabBarController: UITabBarController {
    var presenter: MainTabBarPresentation?
    private var userIconButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserIconButton()
        
        self.presenter?.viewDidLoad()
    }
    
    private func setUserIconButton() {
        userIconButton = UIButton(frame: CGRect(x: .zero, y: .zero, width: 40, height: 40))
        userIconButton?.imageView?.tintColor = .lightGray
        userIconButton?.imageView?.cornerRadius = 20
        userIconButton?.setImage(PlaceHolderImageUtil.userIconPlaceHolderImage(), for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userIconButton ?? UIButton())
    }
    
}

extension MainTabBarController: MainTabBarView {
    func updateUserIcon(imageUrl: String) {
        userIconButton?.kf
            .setImage(with: URL(string: imageUrl),
                      for: .normal,
                      placeholder: PlaceHolderImageUtil.userIconPlaceHolderImage())
    }
}
