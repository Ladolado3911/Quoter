//
//  SignupNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/27/22.
//

import UIKit

protocol SignupNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

    func signupUser(user: UserCredentials) async throws -> QuotieResponse
}

class SignupNetworkWorker: SignupNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func signupUser(user: UserCredentials) async throws -> QuotieResponse {
        let endpoint = QuotieEndpoint.signupUser(body: user)
        let model = Resource(model: QuotieResponse.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
}
