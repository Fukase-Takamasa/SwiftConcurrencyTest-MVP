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

protocol FavoriteArticleListView: AnyObject {
    func showArticlesAndLgtmUsers(articles: [ArticleEntity], lgtmUsersModels: [LgtmUsersModel])
    func reloadTableView()
}

class FavoriteArticleListViewController: UIViewController, StoryboardInstantiatable {
    var presenter: FavoriteArticleListPresenter?
    private var articles: [ArticleEntity] = []
    private var lgtmUsersModels: [LgtmUsersModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissCellHighlight(tableView: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ArticleCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: ArticleCell.reusableIdentifier)
        
        self.presenter?.viewDidLoad()
    }

}

extension FavoriteArticleListViewController: FavoriteArticleListView {
    func showArticlesAndLgtmUsers(articles: [ArticleEntity], lgtmUsersModels: [LgtmUsersModel]) {
        self.articles = articles
        self.lgtmUsersModels = lgtmUsersModels
        self.tableView.reloadData()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
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
        
        let lgtmUsersModel = lgtmUsersModels.first(where: { item in
            return item.articleId == article.id
        })
        cell.lgtmUsersModel = lgtmUsersModel
        cell.collectionView.reloadData()
        
        let isFavoriteArticle = ArticleListUtil.isFavoriteArticle(
            favoriteArticleList: Store.shard.favoriteArticleListSubject.value,
            article: article)
        
        if isFavoriteArticle {
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.favoriteButton.tapPublisher
            .sink { [weak self] element in
                guard let self = self else { return }
                self.presenter?.favoriteButtonTapped(article: article)
            }.store(in: &cell.cancellables)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.tableViewCellTapped(article: articles[indexPath.row])
    }
}
