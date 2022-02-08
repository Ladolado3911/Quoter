//
//  DictumManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/8/22.
//

import UIKit

class DictumManager: NetworkManager {
        
    static func getRandomQuote(completion: @escaping (Result<DictumQuoteVM, Error>) -> Void) {
        guard let url = DictumEndponts.randomQuote else { return }
        getData(url: url, model: Resource(model: DictumQuoteModel.self)) { result in
            switch result {
            case .success(let randomQuote):
                let convertedQuote = DictumQuoteVM(rootModel: randomQuote)
                completion(.success(convertedQuote))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getQuotesOfAuthor(authorID: String, completion: @escaping (Result<[DictumQuoteVM], Error>) -> Void) {
        guard let url = DictumEndponts.getQuotesOfAuthor(authorID: authorID) else { return }
        getData(url: url, model: Resource(model: [DictumQuoteModel].self)) { result in
            switch result {
            case .success(let quotes):
                let convertedQuotes = quotes.map { DictumQuoteVM(rootModel: $0) }
                completion(.success(convertedQuotes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
