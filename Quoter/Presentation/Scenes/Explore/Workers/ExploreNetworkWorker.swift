//
//  QuotieAPIWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

protocol ExploreNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }
}

class ExploreNetworkWorker: ExploreNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func getRandomQuote(genre: String) async throws -> QuoteModel {
        let endpoint = QuotieRandomQuoteEndpoint.getRandomQuote(genre: genre)
        let model = Resource(model: QuoteModel.self)
        let content = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        return content
    }
    
    func getCategories() async throws -> [MainCategoryModel] {
        let endpont = QuotieCategoriesEndpoint.getCategories
        let model = Resource(model: [MainCategoryModel].self)
        let content = try await networkWorker.fetchData(endpoint: endpont, model: model)
        return content
    }
}
