//
//  ArticleListUtil.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 14/7/22.
//

import Foundation

@MainActor
class ArticleListUtil {
    //一覧記事それぞれに紐づくLGTMユーザーリストを並行取得する（可変個数TaskでのTask.group並行処理）
    static func getLgtmUsersOfEachArticles(articles: [Article]) async throws -> [LgtmUsersModel] {
        try await withThrowingTaskGroup(of: (LgtmUsersModel).self, body: { group in
            for (articleId, likesCount) in articles.map({ ($0.id, $0.likesCount) }) {
                group.addTask {
                    let lgtmUsers = try await Repository.getLgtmUsers(articleId: articleId) ?? []
                    //必要なキーを足した独自のModel構造体に差し替えて返却
                    return LgtmUsersModel(articleId: articleId,
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
