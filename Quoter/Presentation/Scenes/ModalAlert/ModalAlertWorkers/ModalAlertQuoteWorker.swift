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
        NetworkManager.getData(url: url, model: Resource(model: QuoteGardenResponse.self)) { result in
            switch result {
            case .success(let gardenResponse):
                if let data = gardenResponse.data {
//                    let unified = Array(Set(data))
//                    let converted = unified.map { QuoteGardenQuoteVM(rootModel: $0) }
//                    let filtered = converted.filter { $0.authorName == authorName }
//                    let shuffled = filtered.shuffled()
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
