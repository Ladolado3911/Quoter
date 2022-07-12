//
//  GalleryNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

struct SavedQuote: Codable {
    var quote: QuoteForSavedQuote
    var image: RegularImageForSavedQuote
}

struct QuoteForSavedQuote: Codable {
    var content: String
    var author: AuthorForSavedQuote
}

struct AuthorForSavedQuote: Codable {
    var authorIDString: String
    var name: String
}

struct RegularImageForSavedQuote: Codable {
    var imageURLString: String
}

protocol GalleryNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }
    
    func getUserQuotes(userIDString: String, userType: AccountType) async throws -> [SavedQuote]
}

class GalleryNetworkWorker: GalleryNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func getUserQuotes(userIDString: String, userType: AccountType) async throws -> [SavedQuote] {
        let endpoint = QuotieEndpoint.getUserQuotes(userIDString: userIDString, userTypeString: userType.rawValue)
        let model = Resource(model: [SavedQuote].self)
        let savedQuotes = try await networkWorker.request(endpoint: endpoint, model: model)
        return savedQuotes
    }
}
