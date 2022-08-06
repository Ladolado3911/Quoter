//
//  ProfileRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfileRouterProtocol {
    var vc: ProfileVCProtocol? { get set }
    var reloadDelegate: ReloadMenuTableViewDelegate? { get set }
    
    func routeToSigninVC()
    
}

final class ProfileRouter: ProfileRouterProtocol {
    weak var vc: ProfileVCProtocol?
    
    var reloadDelegate: ReloadMenuTableViewDelegate?
    
    func routeToSigninVC() {
//        let signinVC = SigninVC()
//        signinVC.modalPresentationStyle = .fullScreen
        MenuModels.shared.menuItems[2].switchVC(with: MenuAuthorizationControllers.signInVC)
        reloadDelegate?.reloadTableView()
        
        //vc?.present(vc: signinVC)
    }
    
}
