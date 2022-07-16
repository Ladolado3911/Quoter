//
//  ExploreQuoteEntity.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

protocol ExploreQuoteProtocol {
    var id: UUID? { get set }
    var content: String? { get set }
    var author: ExploreAuthorProtocol? { get set }
    var quoteImageID: String { get set }
    var quoteImageURLString: String? { get set }
    var isScreenshotAllowed: Bool { get set }
    var isLoading: Bool { get set }
}

protocol ExploreAuthorProtocol {
    var idString: String { get set }
    var name: String { get set }
    var slug: String { get set }
    var authorImageURLString: String { get set }
    var authorDesc: String { get set }
}

struct ExploreQuote: ExploreQuoteProtocol {
    var id: UUID?
    var quoteImageURLString: String?
    var content: String?
    var author: ExploreAuthorProtocol?
    var quoteImageID: String = ""
    var isScreenshotAllowed: Bool = false
    var isLoading: Bool = true
}

struct ExploreAuthor: ExploreAuthorProtocol {
    var idString: String
    var slug: String
    var name: String
    var authorImageURLString: String
    var authorDesc: String
}
