//
//  SigninNetworkWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/27/22.
//

import UIKit
import GoogleSignIn
import FirebaseCore


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
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return QuotieResponse.init(response: .failure(message: "No Client ID")) }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { [unowned self] user, error in
//
//            if let error = error {
//                // ...
//                return
//            }
//
//            guard
//                let authentication = user?.authentication,
//                let idToken = authentication.idToken
//            else {
//                return
//            }
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: authentication.accessToken)
//
//            // ...AuthCredential
//            Auth.auth().signIn(with: credential) { result, error in
//                let user = result?.user
//                //result.
//            }
//
//        }
//    }
    
    
//    func getUserProfileContent(using id: String) async throws -> UserProfileContent {
//        let endpoint = QuotieEndpoint.getUserProfileContent(userID: id)
//        let model = Resource(model: UserProfileContent.self)
//        let response = try await networkWorker.request(endpoint: endpoint, model: model)
//        return response
//    }
}
