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
    private let articleInteractor: ArticleUsecase
    
    init(view: ArticleDetailView,
         router: ArticleDetailWireframe,
         articleInteractor: ArticleUsecase) {
        self.view = view
        self.router = router
        self.articleInteractor = articleInteractor
    }
}

extension ArticleDetailPresenter: ArticleDetailPresentation {
    func viewDidLoad() {
        view?.showWebViewContent()
    }
}
