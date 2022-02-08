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

    static func getRandomImageURL(page: Int) -> URL? {
        //let page = Int.random(in: 1...11)
        return URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&category=nature&q=landscape&page=\(page)&image_type=photo&&per_page=150&safesearch=true")
    }
    
    static func getRelevantPicturesURL(keyword: String) -> URL? {
        URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&per_page=50&image_type=photo&q=\(keyword)&safesearch=true")
    }
    
    static func get50NatureLandscapeURLs() -> URL? {
        URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&per_page=50&image_type=photo&q=landscape&safesearch=true")
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
    
    static func getAuthorImageURL(authorName: String) -> URL? {
        URL(string: "https://en.wikipedia.org/w/api.php?action=query&formatversion=2&titles=\(authorName)&prop=pageimages&format=json&pithumbsize=500")
    }
}

