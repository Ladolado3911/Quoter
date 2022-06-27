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
}

class ExploreNetworkWorker: ExploreNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
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
