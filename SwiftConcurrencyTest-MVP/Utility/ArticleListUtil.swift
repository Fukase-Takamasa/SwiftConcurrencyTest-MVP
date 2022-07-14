//
//  ArticleListUtil.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 14/7/22.
//

import Foundation

class ArticleListUtil {
    
    //一覧記事それぞれに紐づくLGTMユーザーリストを並行取得する（可変個数TaskでのTask.group並行処理）
    static func getLgtmUsersOfEachArticles(articles: [Article]) async throws -> [[LGTM]] {
        try await withThrowingTaskGroup(of: ([LGTM]).self, body: { group in
            for articleId in articles.map({$0.id}) {
                print("articleId: \(articleId)")
                group.addTask {
                    print("group.addTask{ try await Repository.getLgtmUsers(articleId: \(articleId)) }")
                    return try await Repository.getLgtmUsers(articleId: articleId) ?? []
                }
            }
            var lgtms = [[LGTM]]()
            for try await taskResult in group {
                lgtms += [taskResult]
            }
            return lgtms
        })
    }
}
