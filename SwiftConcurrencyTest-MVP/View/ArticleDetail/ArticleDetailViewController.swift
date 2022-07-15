//
//  ArticleDetailViewController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 12/7/22.
//

import UIKit
import Instantiate
import InstantiateStandard
import WebKit
import SkeletonView

protocol ArticleDetailView: AnyObject {
    
}

class ArticleDetailViewController: UIViewController, StoryboardInstantiatable {
    
    var presenter: ArticleDetailPresenter?

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwipeBack()
//        setupWebView()
//        presenter?.showWebViewContent()
    }

    func setupWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //読み込み中にSkeltonViewを表示
        webView.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: .clouds)
        webView.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    func openURL(_ string: String?) {
        guard let urlString = string else { return }
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//PresenterのProtocolに準拠し、各種メソッドが呼び出された時の処理を実装
//extension ArticleDetailViewController: ArticleDetailPresenterInterface {
//    func openUrl(url: URL) {
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//}

extension ArticleDetailViewController: ArticleDetailView {
    
}

extension ArticleDetailViewController: WKUIDelegate, WKNavigationDelegate {
    //WebView読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView読み込み完了 didFinish")
        //SleltonViewを停止
        webView.hideSkeleton()
    }
}
