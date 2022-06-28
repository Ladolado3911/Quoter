//
//  SigninNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/27/22.
//

import UIKit

protocol SigninNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

    func signinUser(user: UserCredentials) async throws -> QuotieResponse
    func getUser(using id: String) async throws -> UserModel
}

class SigninNetworkWorker: SigninNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func signinUser(user: UserCredentials) async throws -> QuotieResponse {
        let endpoint = QuotieEndpoint.signinUser(body: user)
        let model = Resource(model: QuotieResponse.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
    
    func getUser(using id: String) async throws -> UserModel {
        let endpoint = QuotieEndpoint.getUser(userID: id)
        let model = Resource(model: UserModel.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
}
