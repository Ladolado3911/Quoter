//
//  QuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

struct QuoteModel: Codable {
    var content: String
    var author: AuthorModel
    var quoteImageURLString: String
}

struct AuthorModel: Codable {
    var name: String
    var slug: String
    var authorImageURLString: String
}
