//
//  ImageWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

class ExploreImageWorker {
    
    private func get10LandscapeImageItems(completion: @escaping (Result<[ImageItem], Error>) -> Void) {
        guard let url = ImageEndpoints.get10NatureLandscapeURLs() else { return }
        NetworkManager.getData(url: url, model: Resource(model: ImageResponse.self)) { result in
            switch result {
            case .success(let imageResponse):
                if let results = imageResponse.hits {
                    completion(.success(results))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func downloadImage(image: ImageItem, completion: @escaping (UIImage?) -> Void) {
        if let urlString = image.largeImageURL {
            ImageDownloaderWorker.downloadImage(urlString: urlString) { image in
                completion(image)
            }
        }
    }
    
    func get10LandscapeImages(completion: @escaping (Result<[UIImage?], Error>) -> Void) {
        get10LandscapeImageItems { result in
            switch result {
            case .success(let imageItems):
                var images: [UIImage?] = []
                let group = DispatchGroup()
                let queue = DispatchQueue.global(qos: .background)
                for item in imageItems {
                    group.enter()
                    queue.async {
                        // why is self nil here?
                        self.downloadImage(image: item) { image in
                            images.append(image)
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    
                    completion(.success(images))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
