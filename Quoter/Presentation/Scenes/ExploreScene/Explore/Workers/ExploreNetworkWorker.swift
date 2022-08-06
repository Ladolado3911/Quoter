//
//  QuotieAPIWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

protocol ExploreNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

    //func getSmallQuote(genre: Genre) async throws -> QuoteModel
    func saveQuote(quoteIDString: String, imageIDString: String, userIDString: String, userType: AccountType) async throws -> QuotieResponse
    
}

final class ExploreNetworkWorker: ExploreNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func saveQuote(quoteIDString: String, imageIDString: String, userIDString: String, userType: AccountType) async throws -> QuotieResponse {
        let savedQuote = SavedQuoteForEncode(quoteIDString: quoteIDString,
                                             imageIDString: imageIDString,
                                             userIDString: userIDString,
                                             userType: userType.rawValue)
        let endpoint = QuotieEndpoint.saveQuote(body: savedQuote)
        let model = Resource(model: QuotieResponse.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
    
//    func getSmallQuote(genre: Genre) async throws -> QuoteModel {
//        let endpoint = genre == .general ? QuotieEndpoint.getSmallGeneralQuote : QuotieEndpoint.getSmallQuote(genre: genre.rawValue)
//        let model = Resource(model: QuoteModel.self)
//        var quoteModel: QuoteModel
//        do {
//            quoteModel = try await networkWorker.fetchData(endpoint: endpoint, model: model)
//        }
//        catch {
//            print(error)
//            throw error
//        }
//        return quoteModel
//    }
}
