//
//  SignupInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//


import UIKit

protocol SignupInteractorProtocol {
    var presenter: SignupPresenterProtocol? { get set }
    var signupNetworkWorker: SignupNetworkWorker? { get set }
}

final class SignupInteractor: SignupInteractorProtocol {
    var presenter: SignupPresenterProtocol?
    var signupNetworkWorker: SignupNetworkWorker?
}
