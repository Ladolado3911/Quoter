//
//  AuthorNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/16/22.
//

import UIKit

protocol GetContentForSectionProtocol {
    func getContent()
}

protocol CustomNetworkWorkerProtocol {
    
}

protocol AuthorNetworkWorkerProtocol: CustomNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

//    func getSections(authorID: String, categoryName: String) async throws -> [SectionProtocol]
//    func getDataSourceInfo() async throws -> AuthorDataSourceInfoProtocol
    
    func getAboutAuthor(authorID: String) async throws -> AuthorAboutProtocol
    func getAuthorQuotesForSection(authorID: String) async throws -> AuthorQuotesForSectionProtocol
    func getOtherAuthorsForSection(categoryName: String) async throws -> OtherAuthorsForSectionProtocol
}

class AuthorNetworkWorker: AuthorNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
//
//    func getDataSourceInfo() async throws -> AuthorDataSourceInfoProtocol {
//        let endpoint = QuotieEndpoint.getDataSourceInfo
//        let model = Resource(model: AuthorDataSourceInfoEntity.self)
//        let entity = try await networkWorker.fetchData(endpoint: endpoint, model: model)
//        return entity
//    }
    
    func getAboutAuthor(authorID: String) async throws -> AuthorAboutProtocol {
        let endpoint = QuotieEndpoint.getAboutAuthor(authorID: authorID)
        let model = Resource(model: AuthorAboutEntity.self)
        let entity = try await networkWorker.request(endpoint: endpoint, model: model)
        return entity
    }
    
    func getAuthorQuotesForSection(authorID: String) async throws -> AuthorQuotesForSectionProtocol {
        let endpoint = QuotieEndpoint.getAuthorQuotesForSection(authorID: authorID)
        let model = Resource(model: AuthorQuotesForSectionEntity.self)
        let entity = try await networkWorker.request(endpoint: endpoint, model: model)
        return entity
    }
    
    func getOtherAuthorsForSection(categoryName: String) async throws -> OtherAuthorsForSectionProtocol {
        let endpoint = QuotieEndpoint.getOtherAuthorsForSection(categoryName: categoryName)
        let model = Resource(model: OtherAuthorsForSectionEntity.self)
        let entity = try await networkWorker.request(endpoint: endpoint, model: model)
        return entity
    }
    
    
}
