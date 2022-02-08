//
//  DictumEndpoints.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/8/22.
//

import UIKit

struct DictumEndponts {
    
    static func get50Quotes(offset: Int) -> URL? {
        return URL(string: "https://api.fisenko.net/v1/quotes/en?offset=\(offset)")
    }
    
    static func getQuotesOfAuthor(offset: Int, authorID: String) -> URL? {
        return URL(string: "https://api.fisenko.net/v1/authors/en/\(authorID)/quotes?query=&offset=\(offset)")
    }
}
