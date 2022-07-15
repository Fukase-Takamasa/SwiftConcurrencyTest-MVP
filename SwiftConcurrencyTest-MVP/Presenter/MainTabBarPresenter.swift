//
//  MainTabBarPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation

protocol MainTabBarPresentation: AnyObject {
    func viewDidLoad()
}

@MainActor
class MainTabBarPresenter {
    private weak var view: MainTabBarView?
    private let router: MainTabBarWireframe
    private let authorizedUserInterector: AuthorizedUserUsecase
    
    init(view: MainTabBarView,
         router: MainTabBarWireframe,
         authorizedUserInterector: AuthorizedUserUsecase) {
        self.view = view
        self.router = router
        self.authorizedUserInterector = authorizedUserInterector
    }
}

extension MainTabBarPresenter: MainTabBarPresentation {
    func viewDidLoad() {
        self.router.setupViewControllers()
    }
}
