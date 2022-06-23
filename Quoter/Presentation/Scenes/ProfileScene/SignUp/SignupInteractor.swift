//
//  SignupInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//


import UIKit

protocol SignupInteractorProtocol {
    var presenter: SignupPresenterProtocol? { get set }
}

class SignupInteractor: SignupInteractorProtocol {
    var presenter: SignupPresenterProtocol?
}
