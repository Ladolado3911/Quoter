//
//  SigninInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol SigninInteractorProtocol {
    var presenter: SigninPresenterProtocol? { get set }
    var signinNetworkWorker: SigninNetworkWorkerProtocol? { get set }
}

class SigninInteractor: SigninInteractorProtocol {
    var presenter: SigninPresenterProtocol?
    var signinNetworkWorker: SigninNetworkWorkerProtocol?
}
