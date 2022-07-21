//
//  MyPagePresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 19/7/22.
//

import Foundation
import Combine

protocol MyPagePresentation: AnyObject {
    func viewDidLoad()
}

@MainActor
class MyPagePresenter {
    private weak var view: MyPageView?
    private let router: MyPageWireframe
    private let authorizedUserInteractor: AuthorizedUserUsecase
    
    private var cancellables = [AnyCancellable]()

    init(view: MyPageView,
         router: MyPageWireframe,
         authorizedUserInteractor: AuthorizedUserUsecase) {
        self.view = view
        self.router = router
        self.authorizedUserInteractor = authorizedUserInteractor
    }
}

extension MyPagePresenter: MyPagePresentation {
    func viewDidLoad() {
        //Storeからユーザー情報の値を購読
        Store.shard.authorizedUserResponse
            .sink { element in
                guard let user = element else { return }
                //値を受け渡して表示させる
                self.view?.showUserInformation(user: user)
            }.store(in: &cancellables)
    }
}
