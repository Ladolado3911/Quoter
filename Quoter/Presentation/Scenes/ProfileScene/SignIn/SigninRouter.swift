//
//  SigninRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol SigninRouterProtocol {
    var vc: SigninVCProtocol? { get set }
    
    func routeToSignupVC()
}

class SigninRouter: SigninRouterProtocol {
    weak var vc: SigninVCProtocol?
    
    func routeToSignupVC() {
        let signupVC = SignupVC()
        vc?.present(vc: signupVC)
    }
}
