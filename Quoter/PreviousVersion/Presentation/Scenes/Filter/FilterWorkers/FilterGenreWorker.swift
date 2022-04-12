//
//  FilterGenreWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/9/22.
//

import UIKit

class FilterGenreWorker {
    func getGenres(completion: @escaping (Result<[FilterObject], Error>) -> Void) {
        guard let url = QuoteGardenEndpoints.getGenres() else { return }
        NetworkWorker.getData(url: url, model: Resource(model: GenresResponse.self)) { result in
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
