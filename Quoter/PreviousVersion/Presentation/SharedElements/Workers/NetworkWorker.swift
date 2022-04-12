//
//  NetworkManager.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/8/22.
//

import UIKit

struct Resource<T: Codable> {
    var model: T.Type
}

class NetworkWorker {
    static func getData<T: Codable>(url: URL, model: Resource<T>, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let newData = try JSONDecoder().decode(model.model, from: data)
                    DispatchQueue.main.async {
                        completion(.success(newData))
                    }
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
