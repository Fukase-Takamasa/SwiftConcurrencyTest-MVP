//
//  ArticleDetailPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine

protocol ArticleDetailPresentation: AnyObject {
//    func openUrl(url: URL)
}

@MainActor
class ArticleDetailPresenter {
//    private weak var listener: ArticleDetailPresenterInterface?
    
    private weak var view: ArticleDetailView?
    private let router: ArticleDetailWireframe
    private let articleInterector: ArticleUsecase
    
    private var cancellables = [AnyCancellable]()
    
//    private var articleUrl: URL?
    
    //MARK: - output（PresenterからListenerの処理を呼び出す）
    //このPresenterのインターフェースに準拠した抽象的なListener（VC）を注入する
//    init(listener: ArticleDetailPresenterInterface, articleUrl: URL?) {
//        self.listener = listener
//        self.articleUrl = articleUrl
//    }
    init(view: ArticleDetailView,
         router: ArticleDetailWireframe,
         articleInterector: ArticleUsecase) {
        self.view = view
        self.router = router
        self.articleInterector = articleInterector
    }
    
    //MARK: - input（ListenerからPresenterの処理を呼び出す）
//    func showWebViewContent() {
//        guard let articleUrl = articleUrl else { return }
//        listener?.openUrl(url: articleUrl)
//    }
}

extension ArticleDetailPresenter: ArticleDetailPresentation {
//    func openUrl(url: URL) {
//
//    }
}
