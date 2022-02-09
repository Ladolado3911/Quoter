//
//  ImageManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/7/22.
//

import UIKit

class ImageManager: NetworkManager {
    
//    static func loadRelevantImageURL(keyword: String, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let url = QuoteEndpoints.getRelevantPicturesURL(keyword: keyword) else { return }
//        getData(url: url, model: Resource(model: ImageResponse.self)) { result in
//            switch result {
//            case .success(let response):
//                if let hits = response.hits,
//                   let randomItem = hits.randomElement(),
//                   let urlString = randomItem.largeImageURL,
//                   let resultUrl = URL(string: urlString) {
//                    completion(.success(resultUrl))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    static func load50ImageURLs(tag: Tag, completion: @escaping (Result<[URL?], Error>) -> Void) {
        guard let url = ImageEndpoints.getRelevantPicturesURL(keyword: tag.rawValue) else { return }
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
    
    static func load50LandscapeURLs(completion: @escaping (Result<[URL?], Error>) -> Void) {
        guard let url = ImageEndpoints.get50NatureLandscapeURLs() else { return }
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
    
    static func getAuthorImageURLUsingSlug(slug: String, completion: @escaping (Result<(URL, ImageType), Error>) -> Void) {
        var newSlug: String = ""
        if ["Confucius", "Laozi"].contains(slug) {
            getRandomImage { result in
                switch result {
                case .success(let url):
                    completion(.success((url, .nature)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return
        }
        else if slug == "Napoleon_Bonaparte" {
            newSlug = "Napoleon"
        }
        else if slug == "Buddha" {
            newSlug = "Gautama_Buddha"
        }
        else if slug == "Bernard_Shaw" {
            newSlug = "George_Bernard_Shaw"
        }
//        else if slug == "Francois_de_La_Rochefoucauld" {
//            newSlug = "François_de_La_Rochefoucauld"
//        }
        
        else {
            newSlug = slug
        }
        if let url = ImageEndpoints.getAuthorImageURL(authorName: newSlug) {
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
                        getRandomImage { result in
                            switch result {
                            case .success(let url):
                                completion(.success((url, .nature)))
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
                    completion(.success((url, .nature)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
