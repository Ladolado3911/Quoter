//
//  FilterNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/9/22.
//

import UIKit

protocol FilterNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

    func getCategories() async throws -> [MainCategoryModel]
}

class FilterNetworkWorker: FilterNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func getCategories() async throws -> [MainCategoryModel] {
        let endpont = QuotieCategoriesEndpoint.getCategories
        let model = Resource(model: [MainCategoryModel].self)
        let content = try await networkWorker.fetchData(endpoint: endpont, model: model)
        return content
    }
    
    
}
