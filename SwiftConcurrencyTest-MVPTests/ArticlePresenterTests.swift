//
//  ArticlePresenterTests.swift
//  SwiftConcurrencyTest-MVPTests
//
//  Created by ウルトラ深瀬 on 21/7/22.
//

import XCTest
import Alamofire
@testable import SwiftConcurrencyTest_MVP

class ArticlePresenterTests: XCTestCase {
    var view: ArticleListViewMock!
    var router: ArticleListRouterMock!
    var articleInteractor: ArticleInteractorMock!
    var lgtmInteractor: LgtmInteractorMock!
    var presenter: ArticleListPresenter!
    
    @MainActor override func setUp() {
        super.setUp()
        
        view = .init()
        router = .init()
        articleInteractor = .init()
        lgtmInteractor = .init()
        presenter = .init(
            view: view,
            router: router,
            articleInteractor: articleInteractor,
            lgtmInteractor: lgtmInteractor
        )
    }
    
    func test_viewDidLoad() async throws {
        XCTAssertEqual(view.isLoading, false)
        
        //インジケータ表示
        self.view?.handleLoadingIndicator(isFetching: true)
        XCTAssertEqual(view.isLoading, true)
        
        //iOSの人気記事一覧の取得を依頼
        let articles = try await self.articleInteractor.getPopularIosArticles()
        
        guard let articles = articles else {
            XCTFail("articleInteractor.getPopularIosArticlesの結果がnilです")
            return
        }
        XCTAssertTrue(!articles.isEmpty)
        
        let currentShowArticlesCount = view.showArticlesCount
        //viewに成功レスポンスを受け渡して表示させる
        self.view?.showArticles(articles: articles)
        XCTAssertEqual(view.showArticlesCount, currentShowArticlesCount + 1)
        
        XCTAssertEqual(view.isLoading, true)
        //インジケータ非表示
        self.view?.handleLoadingIndicator(isFetching: false)
        XCTAssertEqual(view.isLoading, false)
        
        //取得した各記事のLGTMユーザーリストを非同期で並行取得依頼
        let lgtmUsersModels = try await self.lgtmInteractor
            .getLgtmUsersOfEachArticles(
                articles: articles,
                getLgtmUsers: { articleId in
                    try await self.lgtmInteractor.getLgtmUsers(articleId: articleId)
                })
        
        guard let lgtmUsersModels = lgtmUsersModels else {
            XCTFail("lgtmInteractor.getLgtmUsersOfEachArticlesの結果がnilです")
            return
        }
        XCTAssertTrue(!lgtmUsersModels.isEmpty)
        
        let currentShowLgtmUsersOfEachArticlesCount = view.showLgtmUsersOfEachArticlesCount
        //成功レスポンスを受け渡して処理をさせる
        self.view?.showLgtmUsersOfEachArticles(lgtmUsersModels: lgtmUsersModels)
        XCTAssertEqual(view.showLgtmUsersOfEachArticlesCount, currentShowLgtmUsersOfEachArticlesCount + 1)
    }
}

class ArticleListViewMock: ArticleListView {
    var showArticlesCount = 0
    var showLgtmUsersOfEachArticlesCount = 0
    var reloadTableViewCount = 0
    var isLoading = false
    
    func showArticles(articles: [ArticleEntity]) {
        showArticlesCount += 1
    }
    
    func showLgtmUsersOfEachArticles(lgtmUsersModels: [LgtmUsersModel]) {
        showLgtmUsersOfEachArticlesCount += 1
    }
    
    func reloadTableView() {
        reloadTableViewCount += 1
    }
    
    func handleLoadingIndicator(isFetching: Bool) {
        isLoading = isFetching
    }
}

class ArticleListRouterMock: ArticleListWireframe {
    var showArticleDetailCount = 0
    
    func showArticleDetail(_ article: ArticleEntity) {
        showArticleDetailCount += 1
    }
}

class ArticleInteractorMock: ArticleUsecase {
    func getPopularIosArticles() async throws -> [ArticleEntity]? {
        // Delay the task by 1 second:
        print("今から1秒かかる処理をします")
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("1秒かかる処理成功")
            return [
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
                MockEntites.articleEntityMock,
            ]
        }catch {
            print("1秒かかる処理error: \(error)")
            return nil
        }
    }
    
    func addFavoriteArticle(article: ArticleEntity) {
        
    }
    
    func removeFavoriteArticle(article: ArticleEntity) {
        
    }
}

class LgtmInteractorMock: LgtmUsecase {
    func getLgtmUsers(articleId: String) async throws -> [LgtmEntity]? {
        // Delay the task by 1.5 second:
        print("今から1.5秒かかる処理をします")
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            print("1.5秒かかる処理成功")
            return [MockEntites.lgtmEntityMock]
        }catch {
            print("1.5秒かかる処理error: \(error)")
            return nil
        }
    }
    
    func getLgtmUsersOfEachArticles(
        articles: [ArticleEntity],
        getLgtmUsers: @escaping ((_ articleId: String) async throws -> [LgtmEntity]?)
    ) async throws -> [LgtmUsersModel]? {
        try await withThrowingTaskGroup(of: (LgtmUsersModel).self, body: { group in
            for (articleId, likesCount) in articles.map({ ($0.id, $0.likesCount) }) {
                group.addTask {
                    let lgtmUsers = try await self.getLgtmUsers(articleId: articleId) ?? []
                    return LgtmUsersModel(
                        articleId: articleId,
                        totalLgtmCount: likesCount,
                        lgtms: lgtmUsers)
                }
            }
            var lgtmUsersModels = [LgtmUsersModel]()
            for try await taskResult in group {
                lgtmUsersModels.append(taskResult)
            }
            
            return lgtmUsersModels
        })
    }
}
