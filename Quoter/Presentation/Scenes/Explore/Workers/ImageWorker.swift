//
//  ImageWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

class ImageWorker {
    
    private func get10LandscapeImages(completion: @escaping (Result<[ImageItem], Error>) -> Void) {
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
    
    private func dowloadImage(image: ImageItem) {
        
    }
}
