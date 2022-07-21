//
//  ArticleListUtil.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 21/7/22.
//

import Foundation

class ArticleListUtil {
    static func isFavoriteArticle(favoriteArticleList: [ArticleEntity], article: ArticleEntity) -> Bool {
        return favoriteArticleList.contains(where: { item in
            item.id == article.id
        })
    }
}
