//
//  ProfileRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfileRouterProtocol {
    var vc: ProfileVCProtocol? { get set }
    
    func routeToSigninVC()
    
}

class ProfileRouter: ProfileRouterProtocol {
    weak var vc: ProfileVCProtocol?
    
    func routeToSigninVC() {
        let signinVC = SigninVC()
        vc?.present(vc: signinVC)
    }
    
}
