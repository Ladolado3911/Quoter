//
//  QuoteGardenQuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/9/22.
//

import UIKit

struct QuoteGardenResponse: Codable {
    var data: [QuoteGardenQuoteModel]?
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
