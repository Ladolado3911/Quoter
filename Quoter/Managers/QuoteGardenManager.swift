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
    case noPicture
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

class QuoteGardenManager: NetworkWorker {
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
}
