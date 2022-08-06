//
//  SignupPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol SignupPresenterProtocol {
    var vc: SignupVCProtocol? { get set }
}

final class SignupPresenter: SignupPresenterProtocol {
    var vc: SignupVCProtocol?
}
