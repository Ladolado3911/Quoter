//
//  QuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

struct QuoteModel: Codable {
    var id: UUID?
    var content: String
    var author: AuthorModelForQuote
    var quoteImageURLString: String
    var quoteImageID: String
}

struct AuthorModelForQuote: Codable {
    var id: String
    var name: String
    var slug: String
    var authorImageURLString: String
    var authorDesc: String
}
