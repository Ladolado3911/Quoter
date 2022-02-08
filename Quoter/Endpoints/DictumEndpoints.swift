//
//  DictumEndpoints.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/8/22.
//

import UIKit

struct DictumEndponts {
    
    static var randomQuote: URL? {
        URL(string: "https://api.fisenko.net/v1/quotes/en/random")
    }
    
    static func getQuotesOfAuthor(authorID: String) -> URL? {
        return URL(string: "https://api.fisenko.net/v1/authors/en/\(authorID)/quotes")
    }
}
