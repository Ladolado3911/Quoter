//
//  File.swift
//  
//
//  Created by Lado Tsivtsivadze on 5/2/22.
//

import Foundation

enum QuotieEndpoint: EndpointProtocol {
    
    case getRandomQuote(genre: String)
    case getQuotes(genre: String, limit: Int)
    
    var scheme: Scheme {
        switch self {
        default:
            return .https
        }
    }
    var baseURL: String {
        switch self {
        default:
            return "quotie-quoter-api.herokuapp.com"
        }
    }
    var path: String {
        switch self {
        case .getRandomQuote(let genre):
            return "/randomQuote/\(genre)/"
        case .getQuotes(let genre, let limit):
            return "/getQuotes/\(genre)/\(limit)"
        }
    }
    var parameters: [URLQueryItem] {
        switch self {
        case .getRandomQuote:
            return []
        case .getQuotes:
            return []
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getRandomQuote:
            return .get
        case .getQuotes:
            return .get
        }
    }
}

