//
//  QuoteGradenEndpoints.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/9/22.
//

import UIKit

struct QuoteGardenEndpoints {
    
    static func getRandomQuoteURL() -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes/random")
    }
    
    static func getRandomQuoteURL(genre: String) -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes/random?genre=\(genre)")
    }
    
    static func getQuotesOfAuthor(authorName: String) -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes?limit=500&author=\(convert(str: authorName))")
    }
    
    static func getGenres() -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/genres")
    }
    
    static func convert(str: String) -> String {
        return str.replacingOccurrences(of: " ", with: "%20")
    }
}
