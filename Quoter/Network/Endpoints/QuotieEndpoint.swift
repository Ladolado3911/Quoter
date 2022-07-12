//
//  File.swift
//  
//
//  Created by Lado Tsivtsivadze on 5/2/22.
//

import Foundation
import UIKit

struct GoogleUserCredentials: Codable {
    var email: String
    var isMailVerified: Bool 
}

struct AppleUserCredentials: Codable {
    var appleID: String
    var email: String
    var isMailVerified: Bool
}

struct QuotieID: Codable {
    var id: String
}

enum QuoteSize: String {
    case big
    case small
}

enum QuotieEndpoint: EndpointProtocol {
    
    case getAboutAuthor(authorID: String)
    case getAuthorQuotesForSection(authorID: String)
    case getOtherAuthorsForSection(categoryName: String)
    
    case signupUser(body: UserCredentials)
    case signupWithApple(body: AppleUserCredentials)
    case signinUser(body: UserCredentials)
    case signinWithApple(body: AppleUserCredentials)
    
    case deleteAccount(body: QuotieID)
    
    case getUserProfileContent(userID: String, accountType: AccountType)

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
        case .signinUser:
            return "/signIn/"
        case .getUserProfileContent(let id, let type):
            return "/getUserProfileContent/\(id)/\(type.rawValue)/"
        case .signupWithApple:
            return "/signUpWithApple/"
        case .signinWithApple:
            return "/signInWithApple/"
        case .deleteAccount:
            return "/deleteAccount/"
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
        case .signinUser:
            return .post
        case .signupUser:
            return .post
        case .signupWithApple:
            return .post
        case .signinWithApple:
            return .post
        case .deleteAccount:
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
            
        case .signupWithApple(let appleUserCredentials):
            do {
                let data = try JSONEncoder().encode(appleUserCredentials)
                return data
            }
            catch {
                print(error)
                return nil
            }
            
        case .signinWithApple(let appleUserCredentials):
            do {
                let data = try JSONEncoder().encode(appleUserCredentials)
                return data
            }
            catch {
                print(error)
                return nil
            }
        
        case .signinUser(let userCredentials):
            do {
                let data = try JSONEncoder().encode(userCredentials)
                return data
            }
            catch {
                print(error)
                return nil
            }
            
        case .deleteAccount(let quotieID):
            do {
                let data = try JSONEncoder().encode(quotieID)
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

