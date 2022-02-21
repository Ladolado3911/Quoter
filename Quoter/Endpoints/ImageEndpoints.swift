//
//  ImageEndpoints.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/8/22.
//

import UIKit

let pixabayApiKey = "23037768-717e451d8c6f76d8ebd54cf9d"


struct ImageEndpoints {
    
    static func getRandomImageURL(page: Int) -> URL? {
        return URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&category=nature&q=landscape&page=\(page)&image_type=photo&&per_page=150&safesearch=true")
    }
    
    static func getRelevantPicturesURL(keyword: String) -> URL? {
        URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&per_page=50&image_type=photo&q=\(keyword)&safesearch=true")
    }
    
    static func get10NatureLandscapeURLs() -> URL? {
        URL(string: "https://pixabay.com/api/?key=\(pixabayApiKey)&per_page=10&image_type=photo&q=landscape&safesearch=true&page=\(Int.random(in: 1...9))")
    }
    
    static func getAuthorImageURL(authorName: String) -> URL? {
        URL(string: "https://en.wikipedia.org/w/api.php?action=query&formatversion=2&titles=\(authorName)&prop=pageimages&format=json&pithumbsize=500")
    }
}

