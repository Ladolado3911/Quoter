//
//  QuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

struct QuoteModel: Codable {
    var content: String
    var author: AuthorModelForQuote
    var quoteImageURLString: String
}

struct AuthorModelForQuote: Codable {
    var name: String
    var slug: String
    var authorImageURLString: String
}
