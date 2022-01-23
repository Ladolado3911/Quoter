//
//  QuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/21/22.
//

import UIKit

struct Quote: Codable {
    var content: String?
    var authorSlug: String?
    var author: String?
}

struct QuoteVM {
    
    let rootQuote: Quote
    
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
