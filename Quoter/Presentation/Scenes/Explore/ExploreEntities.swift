//
//  ExploreQuoteEntity.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

protocol ExploreQuoteProtocol {
    var content: String { get set }
    var author: ExploreAuthorProtocol { get set }
    var subCategory: ExploreSubCategoryQuoteProtocol { get set }
}

protocol ExploreAuthorProtocol {
    var name: String { get set }
    var authorImageURLString: String { get set }
    var bigQuotes: [ExploreBigQuoteProtocol] { get set }
}

protocol ExploreBigQuoteProtocol {
    var content: String { get set }
}

protocol ExploreSubCategoryQuoteProtocol {
    var randomImageURLString: String { get set }
}

struct ExploreQuote: ExploreQuoteProtocol {
    var content: String
    var author: ExploreAuthorProtocol
    var subCategory: ExploreSubCategoryQuoteProtocol
}

struct ExploreAuthor: ExploreAuthorProtocol {
    var name: String
    var authorImageURLString: String
    var bigQuotes: [ExploreBigQuoteProtocol]
}

struct ExploreBigQuote: ExploreBigQuoteProtocol {
    var content: String
}

struct ExploreSubCategory: ExploreSubCategoryQuoteProtocol {
    var randomImageURLString: String
}
