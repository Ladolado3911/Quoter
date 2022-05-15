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
    var subCategory: SubCategoryQuoteModel
}

struct AuthorModel: Codable {
    var name: String
    var authorImageURLString: String
    var bigQuotes: [BigQuoteModel]
}

struct SubCategoryQuoteModel: Codable {
    var randomImageURLString: String
}

struct BigQuoteModel: Codable {
    var content: String
}
