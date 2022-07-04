//
//  ViewController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var articles: [Article] = []
    private var cancellables = [AnyCancellable]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ArticleCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: ArticleCell.reusableIdentifier)
        
        Repository.getArticles()
        Store.shard.articlesResponse
            .sink { [weak self] element in
                guard let self = self else { return }
                guard let articles = element else { return }
                self.articles = articles
                self.tableView.reloadData()
                print("vc articlesResponse: \(articles)")
            }.store(in: &cancellables)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reusableIdentifier, for: indexPath) as! ArticleCell
        cell.titleLabel.text = articles[indexPath.row].title
        cell.userNameLabel.text = articles[indexPath.row].user.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
}
