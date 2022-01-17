//
//  QuoteManager.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
//

import UIKit

enum UnwrapError: Error {
    case unwrapError
}

class QuoteManager: NetworkManager {
    static func getAuthors(completion: @escaping (Result<[AuthorVM], Error>) -> Void) {
        getData(url: QuoteEndpoints.authors!, model: Resource(model: Authors.self)) { result in
            switch result {
            case .success(let authors):
                //print(authors)
                guard let unwrappedAuthors = authors.results else {
                    completion(.failure(UnwrapError.unwrapError))
                    return
                }
                let convertedAuthors = unwrappedAuthors.map { AuthorVM(rootAuthor: $0) }
                completion(.success(convertedAuthors))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}


