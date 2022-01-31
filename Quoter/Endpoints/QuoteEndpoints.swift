//
//  QuoteEndpoints.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
//

import UIKit

let pixabayApiKey = "23037768-717e451d8c6f76d8ebd54cf9d"

struct QuoteEndpoints {
    
    static var authors: URL? {
        URL(string: "https://quotable.io/authors?sortBy=quoteCount&order=desc")
    }

    static var getRandomImageURL: URL? {
        URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&category=nature")
    }
    
    static func randomQuote(maxLength: Int) -> URL? {
        URL(string: "https://api.quotable.io/random?maxLength=\(maxLength)")
    }
    
    static func getAuthorImageURL(authorName: String) -> URL? {
        URL(string: "https://en.wikipedia.org/w/api.php?action=query&formatversion=2&titles=\(authorName)&prop=pageimages&format=json&pithumbsize=500")
    }
}

