//
//  SigninNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/27/22.
//

import UIKit

protocol SigninNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }

    func signinUser(user: UserCredentials) async throws -> String
}

class SigninNetworkWorker: SigninNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func signinUser(user: UserCredentials) async throws -> String {
        let endpoint = QuotieEndpoint.signupUser(body: user)
        let model = Resource(model: String.self)
        //let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return ""
    }
}
