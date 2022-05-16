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
}

protocol ExploreAuthorProtocol {
    var name: String { get set }
    var slug: String { get set }
    var authorImageURLString: String { get set }
}

struct ExploreQuote: ExploreQuoteProtocol {
    var quoteImageURLString: String
    var content: String
    var author: ExploreAuthorProtocol
}

struct ExploreAuthor: ExploreAuthorProtocol {
    var slug: String
    var name: String
    var authorImageURLString: String
}
