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
    case registerDevice
    case negotiateQuotes(genre: String, size: QuoteSize, body: [String: AnyHashable])
    
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
        case .registerDevice:
            return "/registerDevice/"
        case .negotiateQuotes(let genre, let size, _):
            return "/getQuotesNegotiated/\(genre)/\(size.rawValue)"
        }
    }
    var parameters: [URLQueryItem] {
        switch self {
        case .getRandomQuote:
            return []
        case .getQuotes:
            return []
        case .registerDevice:
            return []
        case .negotiateQuotes:
            return []
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getRandomQuote:
            return .get
        case .getQuotes:
            return .get
        case .registerDevice:
            return .get
        case .negotiateQuotes:
            return .post
        }
    }
    var body: Data? {
        switch self {
        case .negotiateQuotes(_, _, let body):
            return try? JSONSerialization.data(withJSONObject: body)
        default:
            return nil
        }
    }
}

