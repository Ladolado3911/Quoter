//
//  QuoteManager.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
//

import UIKit

let exceptions = ["Buddha"]

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
    
    static func getAuthorImageURLUsingSlug(slug: String, completion: @escaping (Result<URL, Error>) -> Void) {
        print(slug)
        var newSlug: String = ""
        if slug == "Buddha" {
            newSlug = "Gautama_Buddha"
        }
        else if slug == "Laozi" {
            getRandomImage { result in
                switch result {
                case .success(let url):
                    completion(.success(url))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else if slug == "Confucius" {
            getRandomImage { result in
                switch result {
                case .success(let url):
                    completion(.success(url))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            newSlug = slug
        }
        
        if let url = QuoteEndpoints.getAuthorImageURL(authorName: newSlug) {
            print(url)
            getData(url: url, model: Resource(model: Response.self)) { result in
                switch result {
                case .success(let response):
                    if let query = response.query,
                       let pages = query.pages,
                       let first = pages.first,
                       let thumbnail = first.thumbnail,
                       let source = thumbnail.source,
                       let url = URL(string: source) {
                        completion(.success(url))
                    }
                    else {
                        getRandomImage { result in
                            switch result {
                            case .success(let url):
                                completion(.success(url))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            getRandomImage { result in
                switch result {
                case .success(let url):
                    completion(.success(url))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func getRandomImage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageUrl = QuoteEndpoints.getRandomImageURL else { return }
        
        getData(url: imageUrl, model: Resource(model: ImageResponse.self)) { result in
            switch result {
            case .success(let imageResponse):
                
                if let hits = imageResponse.hits,
                   let randomElement = hits.randomElement(),
                   let resultUrlString = randomElement.largeImageURL,
                   let resultUrl = URL(string: resultUrlString) {
                    completion(.success(resultUrl))
                }
                else {
                    completion(.failure(UnwrapError.unwrapError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


