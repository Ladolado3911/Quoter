//
//  ImageManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/7/22.
//

import UIKit

class ImageManager: NetworkWorker {

    static func load10LandscapeURLs(completion: @escaping (Result<[URL?], Error>) -> Void) {
        guard let url = ImageEndpoints.get10NatureLandscapeURLs() else { return }
        getData(url: url, model: Resource(model: ImageResponse.self)) { result in
            switch result {
            case .success(let imageResponse):
                if let results = imageResponse.hits {
                    let converted = results.map { URL(string: $0.largeImageURL ?? "") }
                    completion(.success(converted))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getAuthorImageURLUsingSlug(slug: String, completion: @escaping (Result<(URL?, ImageType), Error>) -> Void) {
        if let url = ImageEndpoints.getAuthorImageURL(authorName: slug.convertAuthorNameException()) {
            getData(url: url, model: Resource(model: Response.self)) { result in
                switch result {
                case .success(let response):
                    if let query = response.query,
                       let pages = query.pages,
                       let first = pages.first,
                       let thumbnail = first.thumbnail,
                       let source = thumbnail.source,
                       let url = URL(string: source) {
                        completion(.success((url, .author)))
                    }
                    else {
                        completion(.success((nil, .noPicture)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            completion(.success((nil, .noPicture)))
        }
    }

    static func getRandomImage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageUrl = ImageEndpoints.getRandomImageURL(page: Int.random(in: 1...3)) else { return }
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
                    completion(.failure(CustomError.unwrapError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
