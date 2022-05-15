//
//  File.swift
//  
//
//  Created by Lado Tsivtsivadze on 5/2/22.
//

import Foundation

enum QuotieRandomQuoteEndpoint: EndpointProtocol {
    
    case getRandomQuote(genre: String)
    
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
        }
    }
    var parameters: [URLQueryItem] {
        switch self {
        case .getRandomQuote:
            return [
            ]
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getRandomQuote:
            return .get
        }
    }
}

