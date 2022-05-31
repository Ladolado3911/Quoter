//
//  QuotieCategoriesEndpoint.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

enum QuotieCategoriesEndpoint: EndpointProtocol {
    
    case getCategories
    
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
        case .getCategories:
            return "/categories/"
        }
    }
    var parameters: [URLQueryItem] {
        switch self {
        case .getCategories:
            return [
            ]
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getCategories:
            return .get
        }
    }
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
}

