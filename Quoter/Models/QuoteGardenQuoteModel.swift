//
//  QuoteGardenQuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/9/22.
//

import UIKit

struct GenresResponse: Codable {
    var data: [String]?
}

struct QuoteGardenResponse: Codable {
    var pagination: Pagination?
    var data: [QuoteGardenQuoteModel]?
}

struct Pagination: Codable {
    var totalPages: Int?
}

struct QuoteGardenQuoteModel: Codable {
    var quoteText: String?
    var quoteAuthor: String?
}

struct QuoteGardenQuoteVM {
    
    let rootModel: QuoteGardenQuoteModel
    
    var content: String {
        rootModel.quoteText ?? "No Content"
    }
    
    var authorName: String {
        rootModel.quoteAuthor ?? "No Author Name"
    }
    
}
