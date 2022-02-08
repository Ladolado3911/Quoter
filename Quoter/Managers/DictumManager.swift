//
//  DictumManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/8/22.
//

import UIKit

class DictumManager: NetworkManager {
    
    static func get50Quotes(offset: Int, completion: @escaping (Result<[DictumQuoteVM], Error>) -> Void) {
        guard let url = DictumEndponts.get50Quotes(offset: offset) else { return }
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
