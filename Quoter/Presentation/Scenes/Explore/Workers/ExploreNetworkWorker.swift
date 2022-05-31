//
//  QuotieAPIWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

protocol ExploreNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }
    var uniqueQuoteImageURLStrings: [String] { get set }
    var uniqueQuoteContents: [String] { get set }

    func getUniqueRandomQuote(genre: String) async throws -> QuoteModel
    func getRandomQuote(genre: String) async throws -> QuoteModel
    func getQuotesNegotiated(genre: String, size: QuoteSize) async throws -> [QuoteModel]
    func getQuotes(genre: String, limit: Int, size: QuoteSize) async throws -> [QuoteModel]
    func getCategories() async throws -> [MainCategoryModel]
    func registerDevice() async throws
}

class ExploreNetworkWorker: ExploreNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    var uniqueQuoteImageURLStrings: [String] = []
    var uniqueQuoteContents: [String] = []
    
    func getQuotes(genre: String, limit: Int, size: QuoteSize) async throws -> [QuoteModel] {
        let endpoint = QuotieEndpoint.getQuotes(genre: genre, limit: limit, size: size)
        let model = Resource(model: [QuoteModel].self)
        let content = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        return content
    }
    
    func getQuotesNegotiated(genre: String, size: QuoteSize) async throws -> [QuoteModel] {
        try await registerDevice()
        let body = [
            "uuidString": UserDefaults.standard.string(forKey: "DeviceID")
        ]
        let endpoint = QuotieEndpoint.negotiateQuotes(genre: genre, size: size, body: body)
        let model = Resource(model: [QuoteModel].self)
        let content = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        
        return content
    }
    
    func registerDevice() async throws {
        if UserDefaults.standard.string(forKey: "DeviceID") == nil {
            let resource = Resource(model: DeviceModel.self)
            let uniqueID = try await networkWorker.fetchData(endpoint: QuotieEndpoint.registerDevice, model: resource)
            //print(uniqueID.uuidString)
            UserDefaults.standard.setValue(uniqueID.uuidString.lowercased(), forKey: "DeviceID")
        }
    }
    
    func getUniqueRandomQuote(genre: String) async throws -> QuoteModel {
        let endpoint = QuotieEndpoint.getRandomQuote(genre: genre)
        let model = Resource(model: QuoteModel.self)
        let content = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        if uniqueQuoteImageURLStrings.contains(content.quoteImageURLString) || uniqueQuoteContents.contains(content.content) {
            return try await getUniqueRandomQuote(genre: genre)
        }
        else {
            uniqueQuoteImageURLStrings.append(content.quoteImageURLString)
            uniqueQuoteContents.append(content.content)
            return content
        }
    }
    
    func getRandomQuote(genre: String) async throws -> QuoteModel {
        let endpoint = QuotieEndpoint.getRandomQuote(genre: genre)
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
