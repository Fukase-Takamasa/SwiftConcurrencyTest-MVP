//
//  ArticleDetailPresenter.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Combine

protocol ArticleDetailPresenterInterface: AnyObject {
    func openUrl(url: URL)
}

class ArticleDetailPresenter {
    private weak var listener: ArticleDetailPresenterInterface?
    private var cancellables = [AnyCancellable]()
    
    private var articleUrl: URL?
    
    //MARK: - output（PresenterからListenerの処理を呼び出す）
    //このPresenterのインターフェースに準拠した抽象的なListener（VC）を注入する
    init(listener: ArticleDetailPresenterInterface, articleUrl: URL?) {
        self.listener = listener
        self.articleUrl = articleUrl
    }
    
    //MARK: - input（ListenerからPresenterの処理を呼び出す）
    func showWebViewContent() {
        guard let articleUrl = articleUrl else { return }
        listener?.openUrl(url: articleUrl)
    }
}
