//
//  SigninInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

enum SignUpError: Error {
    case couldNotSignUp(message: String)
}

protocol SigninInteractorProtocol {
    var presenter: SigninPresenterProtocol? { get set }
    var signinNetworkWorker: SigninNetworkWorkerProtocol? { get set }
    var signupNetworkWorker: SignupNetworkWorkerProtocol? { get set }
    
    func signupWithApple(appleID: String, email: String?, completion: @escaping (Result<String, SignUpError>) -> Void)
    func signupWithGoogle()
    //func signin()
}

class SigninInteractor: SigninInteractorProtocol {
    var presenter: SigninPresenterProtocol?
    var signinNetworkWorker: SigninNetworkWorkerProtocol?
    var signupNetworkWorker: SignupNetworkWorkerProtocol?
    
    func signupWithApple(appleID: String, email: String?, completion: @escaping (Result<String, SignUpError>) -> Void) {
        let appleUserCredentials = AppleUserCredentials(appleID: appleID, email: email ?? "No Mail", isMailVerified: false)
        Task.init {
            let response = try await signupNetworkWorker?.signupUserWithApple(appleUser: appleUserCredentials)
            //let response = try await signupNetworkWorker?.signupUser(user: userCredentials)
            await MainActor.run {
                switch response?.response {
                case .success(let appleID):
                    completion(.success(appleID))
                case .failure(let errorMessage):
                    completion(.failure(SignUpError.couldNotSignUp(message: errorMessage)))
                default:
                    completion(.failure(SignUpError.couldNotSignUp(message: "response is nil")))
                }
            }
        }
    }
    
    func signupWithGoogle() {
        
    }
    
}
