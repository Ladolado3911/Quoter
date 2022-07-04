//
//  ProfileNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/28/22.
//
import UIKit

enum UserData {
    case mail
    case password
    case credentials
    case isVerified
}

protocol ProfileNetworkWorkerProtocol {
    var networkWorker: NetworkWorkerProtocol { get set }
    
    func getUserProfileContent(using id: String) async throws -> UserProfileContent
    //func getUserMail(using idString: String)
    //func signoutUser()

}

class ProfileNetworkWorker: ProfileNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
//    func getUserMail(using idString: String) {
//        let endpoint =
//    }
    
//    func signoutUser() {
//        let endpoint = QuotieEndpoint.signoutUser(id: <#T##UUID#>)
//
//    }
    
    func getUserProfileContent(using id: String) async throws -> UserProfileContent {
        let endpoint = QuotieEndpoint.getUserProfileContent(userID: id)
        let model = Resource(model: UserProfileContent.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }

}
