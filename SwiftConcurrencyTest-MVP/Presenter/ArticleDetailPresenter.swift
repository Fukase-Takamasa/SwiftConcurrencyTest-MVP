//
//  ArticleDetailPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation

protocol ArticleDetailPresentation: AnyObject {
    func viewDidLoad()
}

@MainActor
class ArticleDetailPresenter {
    private weak var view: ArticleDetailView?
    private let router: ArticleDetailWireframe
    private let articleInterector: ArticleUsecase
    
    init(view: ArticleDetailView,
         router: ArticleDetailWireframe,
         articleInterector: ArticleUsecase) {
        self.view = view
        self.router = router
        self.articleInterector = articleInterector
    }
}

extension ArticleDetailPresenter: ArticleDetailPresentation {
    func viewDidLoad() {
        view?.showWebViewContent()
    }
}
