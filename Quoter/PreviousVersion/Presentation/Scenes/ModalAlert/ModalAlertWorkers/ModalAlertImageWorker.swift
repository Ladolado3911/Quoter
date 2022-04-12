//
//  ModalAlertImageWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

class ModalAlertImageWorker {
    
    private func getAuthorImageURLUsingSlug(slug: String, completion: @escaping (Result<(URL?, ImageType), Error>) -> Void) {
        if let url = ImageEndpoints.getAuthorImageURL(authorName: slug.convertAuthorNameException()) {
            NetworkWorker.getData(url: url, model: Resource(model: Response.self)) { result in
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
    
    func getAuthorImage(authorName: String, completion: @escaping ((UIImage?, ImageType)) -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        getAuthorImageURLUsingSlug(slug: authorName.convertAuthorName()) { result in
            switch result {
            case .success(let tuple):
                if tuple.1 == .noPicture {
                    completion((UIImage(named: "testUpperQuotism"), tuple.1))
                    return
                }
                else {
                    guard let url = tuple.0 else { return }
                    queue.async {
                        ImageDownloaderWorker.downloadImage(url: url) { image in
                            switch tuple.1 {
                            case .author:
                                completion((image, tuple.1))
                            case .noPicture:
                                completion((UIImage(named: "testUpperQuotism"), tuple.1))
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
