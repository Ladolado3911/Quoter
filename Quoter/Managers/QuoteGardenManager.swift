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

final class Filters {
    static var filtersDict: [String: ClosedRange<Int>] = [:]
    
    static func getRangeOf(genre: String) -> ClosedRange<Int> {
        Filters.filtersDict[genre] ?? 1...1
    }
    
    
    
    
}

class FilterObject {
    let genre: String
    var pageRange: ClosedRange<Int>?
    
    init(genre: String, pageRange: ClosedRange<Int>?) {
        self.genre = genre
        self.pageRange = pageRange
    }
}

class QuoteGardenManager: NetworkManager {
    
    static func getGenres(completion: @escaping (Result<[FilterObject], Error>) -> Void) {
        guard let url = QuoteGardenEndpoints.getGenres() else { return }
        getData(url: url, model: Resource(model: GenresResponse.self)) { result in
            switch result {
            case .success(let genresResponse):
                if let genresData = genresResponse.data {
                    let convertedGenres = genresData.map { FilterObject(genre: $0, pageRange: nil) }
                    completion(.success(convertedGenres))
                }
                else {
                    completion(.failure(CustomError.unwrapError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func get50Quotes(genre: String, page: Int, completion: @escaping (Result<[QuoteGardenQuoteVM], Error>) -> Void) {
        guard let url = QuoteGardenEndpoints.get50QuotesURL(genre: genre, page: page) else { return }
        getData(url: url, model: Resource(model: QuoteGardenResponse.self)) { result in
            switch result {
            case .success(let gardenResponse):
                if let data = gardenResponse.data {
                    if let pagination = gardenResponse.pagination,
                       let totalPages = pagination.totalPages {
//                        let indexInFilters = Filters.filterObjects.firstIndex { $0.genre == genre }
//                        Filters.filterObjects[indexInFilters!].pageRange = 1...totalPages
                        Filters.filtersDict[genre] = 1...totalPages
                    }
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
