//
//  MyPageRouter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 19/7/22.
//

import UIKit

protocol MyPageWireframe: AnyObject {
    
}

@MainActor
class MyPageRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // - DI
    static func assembleModules() -> MyPageViewController {
        let view = MyPageViewController.instantiate()
        let router = MyPageRouter(viewController: view)
        let interactor = AuthorizedUserInteractor()
        let presenter = MyPagePresenter(view: view, router: router, authorizedUserInteractor: interactor)
        
        view.presenter = presenter
        return view
    }
}

extension MyPageRouter: MyPageWireframe {

}
