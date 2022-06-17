//
//  AuthorNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/16/22.
//

import UIKit

protocol AuthorNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

    func getSections(authorID: String, categoryName: String) async throws -> [SectionProtocol]
    
    func getAboutAuthor(authorID: String) async throws -> AuthorAboutProtocol
    func getAuthorQuotesForSection(authorID: String) async throws -> AuthorQuotesForSectionProtocol
    func getOtherAuthorsForSection(categoryName: String) async throws -> OtherAuthorsForSectionProtocol
}

class AuthorNetworkWorker: AuthorNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func getSections(authorID: String, categoryName: String) async throws -> [SectionProtocol] {
        let content = try await withThrowingTaskGroup(of: SectionProtocol?.self, returning: [SectionProtocol?]?.self) { [weak self] group in
            guard let self = self else { return nil }
            for task in 0..<2 {
                group.addTask {
                    switch task {
                    case 0:
                        let authorQuotesForSection = try await self.getAuthorQuotesForSection(authorID: authorID)
                        return authorQuotesForSection
                    case 1:
                        let otherAuthorsForSection = try await self.getOtherAuthorsForSection(categoryName: categoryName)
                        return otherAuthorsForSection
                    default:
                        return nil
                    }
                }
            }
            return try await group.reduce(into: [SectionProtocol]()) { result, data in
                result?.append(data)
            }
        }
        return content?.compactMap { $0 } ?? []
    }
    
    func getAboutAuthor(authorID: String) async throws -> AuthorAboutProtocol {
        let endpoint = QuotieEndpoint.getAboutAuthor(authorID: authorID)
        let model = Resource(model: AuthorAboutEntity.self)
        let entity = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        return entity
    }
    
    func getAuthorQuotesForSection(authorID: String) async throws -> AuthorQuotesForSectionProtocol {
        let endpoint = QuotieEndpoint.getAuthorQuotesForSection(authorID: authorID)
        let model = Resource(model: AuthorQuotesForSectionEntity.self)
        let entity = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        return entity
    }
    
    func getOtherAuthorsForSection(categoryName: String) async throws -> OtherAuthorsForSectionProtocol {
        let endpoint = QuotieEndpoint.getOtherAuthorsForSection(categoryName: categoryName)
        let model = Resource(model: OtherAuthorsForSectionEntity.self)
        let entity = try await networkWorker.fetchData(endpoint: endpoint, model: model)
        return entity
    }
    
    
}
