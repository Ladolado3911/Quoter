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
    
    static func getRandomQuote(completion: @escaping (Result<QuoteVM, Error>) -> Void) {
        getData(url: QuoteEndpoints.randomQuote!, model: Resource(model: Quote.self)) { result in
            switch result {
            case .success(let randomQuote):
                completion(.success(QuoteVM(rootQuote: randomQuote)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getAuthorImageURLUsingSlug(slug: String, comletion: @escaping (Result<URL, Error>) -> Void) {
        print(slug)
        guard let url = QuoteEndpoints.getAuthorImageURL(authorName: slug) else { return }
        getData(url: url, model: Resource(model: Response.self)) { result in
            switch result {
            case .success(let response):
                if let thumbnail = response.query?.pages?.first!.thumbnail {
                    let urlString = thumbnail.source
                    if let url = URL(string: urlString!) {
                        comletion(.success(url))
                    }
                    else {
                        comletion(.failure(UnwrapError.unwrapError))
                    }
                }
            case .failure(let error):
                comletion(.failure(error))
            }
        }
    }
}


