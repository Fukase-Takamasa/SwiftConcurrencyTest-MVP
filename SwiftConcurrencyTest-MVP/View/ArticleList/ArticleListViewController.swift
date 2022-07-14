//
//  ArticleListViewController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 8/7/22.
//

import UIKit
import Instantiate
import InstantiateStandard
import PKHUD
import Kingfisher
import CombineCocoa

class ArticleListViewController: UIViewController, StoryboardInstantiatable {
    private var presenter: ArticleListPresenter?
    private var articles: [Article] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissCellHighlight(tableView: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ArticleCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: ArticleCell.reusableIdentifier)
        
        //PresenterのListenerに自身を代入
        presenter = ArticleListPresenter(listener: self)
//        presenter?.getAuthorizedUser()
        presenter?.getMonthlyPupularArticles()
    }

}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reusableIdentifier, for: indexPath) as! ArticleCell
        cell.userIconImageView.kf.setImage(with: URL(string: article.user.profileImageUrl ?? ""))
        cell.titleLabel.text = articles[indexPath.row].title
        cell.userNameLabel.text = articles[indexPath.row].user.name
        
        cell.favoriteButton.tapPublisher
            .sink { [weak self] element in
                guard let self = self else { return }

            }.store(in: &cell.cancellables)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let vc = ArticleDetailViewController.instantiate()
        let presenter = ArticleDetailPresenter(listener: vc, articleUrl: URL(string: article.url))
        vc.presenter = presenter
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//PresenterのProtocolに準拠し、各種メソッドが呼び出された時の処理を実装
extension ArticleListViewController: ArticleListPresenterInterface {
    func authorizedUserResponse(user: User) {
       
    }
    
    func monthlyPopularArticlesResponse(articles: [Article]) {
        self.articles = articles
        self.tableView.reloadData()
    }
    
    func errorResponse(error: Error) {
        
    }
    
    func isFetching(_ flag: Bool) {
        flag ? HUD.show(.progress) : HUD.hide()
    }
}
