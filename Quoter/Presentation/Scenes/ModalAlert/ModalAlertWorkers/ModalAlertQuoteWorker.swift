//
//  ModalAlertQuoteWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

class ModalAlertQuoteWorker {
    
    func getQuotesOfAuthors(authorName: String, completion: @escaping (Result<[QuoteGardenQuoteModel], Error>) -> Void) {
        guard let url = QuoteGardenEndpoints.getQuotesOfAuthor(authorName: authorName) else { return }
        NetworkWorker.getData(url: url, model: Resource(model: QuoteGardenResponse.self)) { result in
            switch result {
            case .success(let gardenResponse):
                if let data = gardenResponse.data {
                    completion(.success(data))
                }
                else {
                    completion(.failure(CustomError.unwrapError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
