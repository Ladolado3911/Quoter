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
    
    case getAboutAuthor(authorID: String)
    case getAuthorQuotesForSection(authorID: String)
    case getOtherAuthorsForSection(categoryName: String)
    
    case signupUser(body: UserCredentials)

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
        case .getAboutAuthor(let id):
            return "/getAuthorAbout/\(id)/"
        case .getAuthorQuotesForSection(let id):
            return "/getAuthorQuotesSection/\(id)/"
        case .getOtherAuthorsForSection(let name):
            return "/getOtherAuthorsInCategory/\(name)/"
        case .signupUser:
            return "/signUp/"
        }
    }
    var parameters: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
    var method: HTTPMethod {
        switch self {
        case .signupUser:
            return .post
        default:
            return .get
        }
    }
    var body: Data? {
        switch self {
        case .signupUser(let userCredentials):
            do {
                let data = try JSONEncoder().encode(userCredentials)
                return data
            }
            catch {
                print(error)
                return nil
            }
            
        default:
            return nil
        }
    }
}

