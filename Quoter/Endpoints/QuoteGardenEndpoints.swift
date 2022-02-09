//
//  QuoteGradenEndpoints.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/9/22.
//

import UIKit

struct QuoteGardenEndpoints {
    
    static func get50QuotesURL() -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes?limit=50&page=\(Int.random(in: 1...1450))")
    }
    
    static func getQuotesOfAuthor(authorName: String) -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes?limit=500&author=\(authorName)")
    }
}
