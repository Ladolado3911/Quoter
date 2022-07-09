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
    func signinWithApple(user: AppleUserCredentials) async throws -> QuotieResponse
    //func signinWithGoogle(user: GoogleUserCredentials, presentingVC: UIViewController) async throws -> QuotieResponse
//    func getUserProfileContent(using id: String) async throws -> UserProfileContent
}

class SigninNetworkWorker: SigninNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
    func signinUser(user: UserCredentials) async throws -> QuotieResponse {
        let endpoint = QuotieEndpoint.signinUser(body: user)
        let model = Resource(model: QuotieResponse.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
    
    func signinWithApple(user: AppleUserCredentials) async throws -> QuotieResponse {
        let endpoint = QuotieEndpoint.signinWithApple(body: user)
        let model = Resource(model: QuotieResponse.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
    
//    func signinWithGoogle(user: GoogleUserCredentials, presentingVC: UIViewController) async throws -> QuotieResponse {
//
//    }
//
//
//    func getUserProfileContent(using id: String) async throws -> UserProfileContent {
//        let endpoint = QuotieEndpoint.getUserProfileContent(userID: id)
//        let model = Resource(model: UserProfileContent.self)
//        let response = try await networkWorker.request(endpoint: endpoint, model: model)
//        return response
//    }
}
