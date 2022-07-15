//
//  FavoriteArticleListViewController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 14/7/22.
//

import UIKit
import Instantiate
import InstantiateStandard
import PKHUD
import Kingfisher
import CombineCocoa

class FavoriteArticleListViewController: UIViewController, StoryboardInstantiatable {
    private var presenter: FavoriteArticleListPresenter?
    private var articles: [Article] = []
    private var lgtmUsersModelsOfEachArticles: [LgtmUsersModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissCellHighlight(tableView: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ArticleCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: ArticleCell.reusableIdentifier)
        
        //PresenterのListenerに自身を代入
        presenter = FavoriteArticleListPresenter(listener: self)
    }

}

extension FavoriteArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular, scale: .default)
        let placeHolderImage = UIImage(systemName: "person.crop.circle", withConfiguration: systemImageConfig)
        
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reusableIdentifier, for: indexPath) as! ArticleCell
        
        cell.userIconImageView.image = placeHolderImage
        cell.userIconImageView.kf.setImage(with: URL(string: article.user.profileImageUrl ?? ""), placeholder: placeHolderImage)
        cell.titleLabel.text = articles[indexPath.row].title
        cell.userNameLabel.text = articles[indexPath.row].user.name
        
        let lgtmUsersModel = lgtmUsersModelsOfEachArticles.first(where: { item in
            return item.articleId == article.id
        })
        cell.lgtmUsersModel = lgtmUsersModel
        cell.collectionView.reloadData()
        
        let storeValue = Store.shard.favoriteArticleListSubject.value
        let isFavoriteArticle = storeValue.contains(where: { item in
            item.id == article.id
        })
        if isFavoriteArticle {
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.favoriteButton.tapPublisher
            .sink { [weak self] element in
                guard let self = self else { return }
                if isFavoriteArticle {
                    //現在のstoreValueからタップしたセルのarticleを削除したリストを流す
                    Store.shard.favoriteArticleListSubject.send(storeValue.filter({ item in item.id != article.id}))
                }else {
                    //現在のstoreValueにタップしたセルのarticleを追加したリストを流す
                    Store.shard.favoriteArticleListSubject.send(storeValue + [article])
                }
                self.tableView.reloadData()
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
extension FavoriteArticleListViewController: FavoriteArticleListPresenterInterface {
    func showFavoriteArticles(articles: [Article], lgtmUsersModelsOfEachArticles: [LgtmUsersModel]) {
        self.articles = articles
        self.lgtmUsersModelsOfEachArticles = lgtmUsersModelsOfEachArticles
        self.tableView.reloadData()
    }
}
