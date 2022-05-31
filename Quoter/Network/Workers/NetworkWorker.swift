//
//  NetworkManager.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/8/22.
//

import Foundation

enum NetworkError: Error {
    case serverError(error: Error)
    case noData
    case cantDecode
    case noURL
}

protocol NetworkWorkerProtocol {
    func fetchData<T: Codable>(endpoint: EndpointProtocol, model: Resource<T>) async throws -> T
}

struct Resource<T: Codable> {
    var model: T.Type
}

class NetworkWorker: NetworkWorkerProtocol {

    func fetchData<T: Codable>(endpoint: EndpointProtocol, model: Resource<T>) async throws -> T {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.queryItems = endpoint.parameters
        components.path = endpoint.path
        components.host = endpoint.baseURL
        
        guard let url = components.url else { throw NetworkError.noURL }
        
        do {
            var request = URLRequest(url: url)
            switch endpoint.method {
            case .get:
                break
            case .post:
                request.allHTTPHeaderFields = [
                    "Content-Type": "application/json"
                ]
                request.httpMethod = endpoint.method.rawValue
                request.httpBody = endpoint.body
            }
            //request.httpBody = endpoint.body
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("HTTP head", response)
            let content = try JSONDecoder().decode(model.model, from: data)
            return content
        }
        catch {
            print("request failed:", error)
            throw error
        }
    }
    
}
