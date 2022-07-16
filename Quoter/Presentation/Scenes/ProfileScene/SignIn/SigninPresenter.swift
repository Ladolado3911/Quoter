//
//  SigninPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol SigninPresenterProtocol {
    var vc: SigninVCProtocol? { get set }
}

class SigninPresenter: SigninPresenterProtocol {
    var vc: SigninVCProtocol?
}
