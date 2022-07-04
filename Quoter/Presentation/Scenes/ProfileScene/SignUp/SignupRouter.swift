//
//  SignupRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//
import UIKit

protocol SignupRouterProtocol {
    var vc: SignupVCProtocol? { get set }
    
    func routeToProfileVC()
}

class SignupRouter: SignupRouterProtocol {
    weak var vc: SignupVCProtocol?
    
    func routeToProfileVC() {
        let profileVC = ProfileVC()
        profileVC.modalPresentationStyle = .fullScreen
        profileVC.modalTransitionStyle = .crossDissolve
        vc?.present(vc: profileVC)
    }
}
