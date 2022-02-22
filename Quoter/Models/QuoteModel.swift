//
//  QuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/21/22.
//

import UIKit

struct Quote: Codable {
    var tags: [String]?
    var content: String?
    var authorSlug: String?
    var author: String?
}

struct QuoteVM {
    
    let rootQuote: Quote
    
    var lastTag: String {
        let arr = rootQuote.tags ?? []
        if arr.isEmpty {
            return ""
        }
        else {
            return arr.last ?? ""
        }
    }
    
    var content: String {
        rootQuote.content ?? "No Content"
    }
    
    var authorSlug: String {
        rootQuote.authorSlug ?? "No Slug"
    }
    
    var author: String {
        rootQuote.author ?? "No Author Name"
    }
}

struct QuoteBatchResponse: Codable {
    var totalPages: Int?
    var results: [Quote]?
}
