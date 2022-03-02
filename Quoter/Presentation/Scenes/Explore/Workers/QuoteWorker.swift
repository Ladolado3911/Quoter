//
//  ExploreAnimationWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

class QuoteWorker {
    
    private func getRandomQuote(genre: String, completion: @escaping (Result<QuoteGardenQuoteModel, Error>) -> Void) {
        guard let url = QuoteGardenEndpoints.getRandomQuoteURL(genre: genre) else { return }
        NetworkManager.getData(url: url, model: Resource(model: QuoteGardenResponse.self)) { result in
            switch result {
            case .success(let gardenResponse):
                if let data = gardenResponse.data,
                   let quote = data.first {
                    completion(.success(quote))
                }
                else {
                    completion(.failure(CustomError.unwrapError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func get10RandomQuotes(genre: String, completion: @escaping (Result<[QuoteGardenQuoteModel], Error>) -> Void) {
        let group = DispatchGroup()
        var quoteModels: [QuoteGardenQuoteModel] = []
        for _ in 0..<10 {
            group.enter()
            getRandomQuote(genre: genre) { result in
                switch result {
                case .success(let quote):
                    quoteModels.append(quote)
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(.success(quoteModels))
        }
    }
}
