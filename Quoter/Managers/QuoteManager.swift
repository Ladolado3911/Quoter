//
//  QuoteManager.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
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

class QuoteManager: NetworkManager {
    
    static func load150Quotes(page: Int, maxLength: Int, completion: @escaping (Result<[QuoteVM], Error>) -> Void) {
        
        guard let url = QuotableEndpoints.get150QuotesURL(page: page, maxLength: maxLength) else { return }
        
        getData(url: url, model: Resource(model: QuoteBatchResponse.self)) { result in
            switch result {
            case .success(let response):
                if let totalPages = response.totalPages,
                   let results = response.results {
                    if page > totalPages {
                        completion(.failure(CustomError.pageCountMismatchError))
                    }
                    let convertedResults = results.map { QuoteVM(rootQuote: $0) }
                    completion(.success(convertedResults))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getQuotesOfAuthor(authorSlug: String, page: Int, completion: @escaping (Result<[AuthorQuoteVM], Error>) -> Void) {
        guard let url = QuotableEndpoints.quotesOfAuthorURL(authorSlug: authorSlug, page: page) else { return }
        getData(url: url,
                model: Resource(model: AuthorQuotesResponse.self)) { result in
            switch result {
            case .success(let response):
                if let results = response.results,
                   let pageCount = response.totalPages {
                    if page > pageCount {
                        print(pageCount)
                        completion(.failure(CustomError.pageCountMismatchError))
                    }
                    else {
                        let newQuotes = results.map { AuthorQuoteVM(rootAuthor: $0) }
                        completion(.success(newQuotes))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


