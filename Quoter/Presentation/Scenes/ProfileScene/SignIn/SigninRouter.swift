//
//  SigninRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol SigninRouterProtocol {
    var vc: SigninVCProtocol? { get set }
    
    var reloadDelegate: ReloadMenuTableViewDelegate? { get set }
    
    func routeToSignupVC(presentFromSignin: @escaping () -> Void)
    func routeToProfileVC()
}

class SigninRouter: SigninRouterProtocol {
    weak var vc: SigninVCProtocol?
    
    var reloadDelegate: ReloadMenuTableViewDelegate?
    
    func routeToSignupVC(presentFromSignin: @escaping () -> Void) {
        let signupVC = SignupVC()
        signupVC.presentFromSignin = presentFromSignin
        vc?.present(vc: signupVC)
    }
    
    func routeToProfileVC() {
        let profileVC = ProfileVC()
        MenuModels.shared.menuItems[2].switchVC(with: profileVC)
        reloadDelegate?.reloadTableView()
        
        
        //profileVC.interactor?.userIDString = userIDString
//        profileVC.modalPresentationStyle = .fullScreen
//        profileVC.modalTransitionStyle = .crossDissolve
        vc?.present(vc: profileVC)
    }
    
}
