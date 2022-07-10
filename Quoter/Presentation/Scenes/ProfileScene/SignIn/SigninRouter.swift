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
    func routeToProfileVC(type: SigninVCType)
}

class SigninRouter: SigninRouterProtocol {
    weak var vc: SigninVCProtocol?
    
    var reloadDelegate: ReloadMenuTableViewDelegate?
    
    func routeToSignupVC(presentFromSignin: @escaping () -> Void) {
        let signupVC = SignupVC()
        signupVC.presentFromSignin = presentFromSignin
        vc?.present(vc: signupVC)
    }
    
    func routeToProfileVC(type: SigninVCType) {
//        let profileVC = ProfileVC()
//        profileVC.modalPresentationStyle = .fullScreen
        if let profileVC = MenuAuthorizationControllers.profileVC as? ProfileVCProtocol {
            profileVC.interactor?.userIDString = CurrentUserLocalManager.shared.getCurrentUserID()
        }
        MenuModels.shared.menuItems[2].switchVC(with: MenuAuthorizationControllers.profileVC)
        
        switch type {
        case .menu:
            reloadDelegate?.reloadTableView()
        case .explore:
            reloadDelegate?.reloadFromExplore()
        }
        
        
        
        //profileVC.interactor?.userIDString = userIDString
//        profileVC.modalPresentationStyle = .fullScreen
//        profileVC.modalTransitionStyle = .crossDissolve
        //vc?.present(vc: profileVC)
    }
    
}
