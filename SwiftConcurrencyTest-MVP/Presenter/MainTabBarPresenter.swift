//
//  MainTabBarPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 15/7/22.
//

import Foundation

protocol MainTabBarPresentation: AnyObject {
    func viewDidLoad()
    func userIconButtonTapped()
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
        //BottomTabに対応した各画面の表示
        self.router.setupViewControllers()
        
        //NaviBar上のユーザーアイコン画像に使うユーザー情報を取得
        Task {
            let authorizedUser = try await authorizedUserInterector.getAuthorizedUser()
            view?.updateUserIcon(imageUrl: authorizedUser?.profileImageUrl ?? "")
        }
    }
    
    func userIconButtonTapped() {
        router.showMyPage()
    }
}
