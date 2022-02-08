//
//  QuoteEndpoints.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
//

import UIKit

//let pixabayApiKey = "23037768-717e451d8c6f76d8ebd54cf9d"

struct QuotableEndpoints {
    
    static var authors: URL? {
        URL(string: "https://quotable.io/authors?sortBy=quoteCount&order=desc")
    }

    static func get150QuotesURL(page: Int, maxLength: Int) -> URL? {
        URL(string: "https://quotable.io/quotes?limit=150&page=\(page)&maxLength=\(maxLength)")
    }
    
    static func quotesOfAuthorURL(authorSlug: String) -> URL? {
        URL(string: "https://quotable.io/quotes?author=\(authorSlug)&page=1")
    }
    
    static func quotesOfAuthorURL(authorSlug: String, page: Int) -> URL? {
        URL(string: "https://quotable.io/quotes?author=\(authorSlug)&page=\(page)")
    }
    
    static func randomQuote(maxLength: Int) -> URL? {
        URL(string: "https://api.quotable.io/random?maxLength=\(maxLength)")
    }
}



