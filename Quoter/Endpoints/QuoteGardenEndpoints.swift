//
//  QuoteGradenEndpoints.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/9/22.
//

import UIKit
//
//enum Genre: String {
//    case all = ""
//    case age
//    case alone
//    case amazing
//    case anger
//
//
//}
//
//// this struct might need time to time maintenance
//struct GenrePageRange {
//    static let all = Int.random(in: 1...1450)
//    static let music = Int.random(in: 1...980)
//
//    //case music = Int.random(in: 1...1450)
//
////    private func getValue(range: ClosedRange<Int>) -> Int {
////        Int.random(in: range)
////    }
//}



struct QuoteGardenEndpoints {
    
    static func getRandomQuoteURL() -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes/random")
    }
    
    static func getRandomQuoteURL(genre: String) -> URL? {
        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes/random?genre=\(genre)")
    }
    
    // this endpoint might need time to time maintenance
//    static func get50QuotesURL(genre: String, page: Int) -> URL? {
//        URL(string: "https://quote-garden.herokuapp.com/api/v3/quotes?limit=50&page=\(page)&genre=\(genre)")
//    }
    
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
