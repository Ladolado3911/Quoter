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
    func deleteAccount() async throws -> QuotieResponse
    //func getUserMail(using idString: String)
    //func signoutUser()

}

final class ProfileNetworkWorker: ProfileNetworkWorkerProtocol {
    
    var networkWorker: NetworkWorkerProtocol = NetworkWorker()
    
//    func getUserMail(using idString: String) {
//        let endpoint =
//    }
    
//    func signoutUser() {
//        let endpoint = QuotieEndpoint.signoutUser(id: <#T##UUID#>)
//
//    }
    
    func getUserProfileContent(using id: String) async throws -> UserProfileContent {
        //add animation here when i return 
        let endpoint = QuotieEndpoint.getUserProfileContent(userID: id, accountType: CurrentUserLocalManager.shared.type!)
        let model = Resource(model: UserProfileContent.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }
    
    func deleteAccount() async throws -> QuotieResponse {
        let quotieID = QuotieID(id: CurrentUserLocalManager.shared.getCurrentUserID()!)
        let endpoint = QuotieEndpoint.deleteAccount(body: quotieID)
        let model = Resource(model: QuotieResponse.self)
        let response = try await networkWorker.request(endpoint: endpoint, model: model)
        return response
    }

}
