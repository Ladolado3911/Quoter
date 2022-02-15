//
//  QuoteGardenManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/9/22.
//

import UIKit


let exceptions = ["Buddha"]

enum CustomError: Error {
    case unwrapError
    case pageCountMismatchError
    case needsRecursion
}

enum ImageType {
    case nature
    case author
}

class QuoteGardenManager: NetworkManager {
    
    static func get50Quotes(completion: @escaping (Result<[QuoteGardenQuoteVM], Error>) -> Void) {
        guard let url = QuoteGardenEndpoints.get50QuotesURL() else { return }
        getData(url: url, model: Resource(model: QuoteGardenResponse.self)) { result in
            switch result {
            case .success(let gardenResponse):
                if let data = gardenResponse.data {
                    let converted = data.map { QuoteGardenQuoteVM(rootModel: $0) }
                    let filtered = converted.filter { $0.content.count <= 120 }
                    let shuffled = filtered.shuffled()
                    completion(.success(shuffled))
                }
                else {
                    completion(.failure(CustomError.unwrapError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getQuotesOfAuthor(authorName: String, completion: @escaping (Result<[QuoteGardenQuoteVM], Error>) -> Void) {
        
        guard let url = QuoteGardenEndpoints.getQuotesOfAuthor(authorName: authorName) else { return }
        
        getData(url: url, model: Resource(model: QuoteGardenResponse.self)) { result in
            switch result {
            case .success(let gardenResponse):
                if let data = gardenResponse.data {
                    let converted = data.map { QuoteGardenQuoteVM(rootModel: $0) }
                    let shuffled = converted.shuffled()
                    completion(.success(shuffled))
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
