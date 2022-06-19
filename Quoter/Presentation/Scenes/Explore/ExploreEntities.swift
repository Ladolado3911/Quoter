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
    var quoteImageURLString: String { get set }
    var isScreenshotAllowed: Bool { get set }
}

protocol ExploreAuthorProtocol {
    var idString: String { get set }
    var name: String { get set }
    var slug: String { get set }
    var authorImageURLString: String { get set }
}

struct ExploreQuote: ExploreQuoteProtocol {
    var quoteImageURLString: String
    var content: String
    var author: ExploreAuthorProtocol
    var isScreenshotAllowed: Bool = false
}

struct ExploreAuthor: ExploreAuthorProtocol {
    var idString: String
    var slug: String
    var name: String
    var authorImageURLString: String
}
