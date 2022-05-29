//
//  File.swift
//  
//
//  Created by Lado Tsivtsivadze on 5/2/22.
//

import Foundation

enum QuoteSize: String {
    case big
    case small
}

enum QuotieEndpoint: EndpointProtocol {
    
    case getRandomQuote(genre: String)
    case getQuotes(genre: String, limit: Int, size: QuoteSize)
    
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
        case .getQuotes(let genre, let limit, let size):
            return "/getQuotes/\(genre)/\(limit)/\(size.rawValue)"
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

