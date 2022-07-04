//
//  SignupRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//
import UIKit

protocol ReloadMenuTableViewDelegate {
    func reloadTableView()
}

protocol SignupRouterProtocol {
    var vc: SignupVCProtocol? { get set }
    var reloadDelegate: ReloadMenuTableViewDelegate? { get set }
    
    func routeToProfileVC()
}

class SignupRouter: SignupRouterProtocol {
    weak var vc: SignupVCProtocol?
    
    var reloadDelegate: ReloadMenuTableViewDelegate?
    
    func routeToProfileVC() {
        let profileVC = ProfileVC()
        MenuModels.shared.menuItems[2].switchVC(with: profileVC)
        reloadDelegate?.reloadTableView()
//        profileVC.modalPresentationStyle = .fullScreen
//        profileVC.modalTransitionStyle = .crossDissolve
//        vc?.present(vc: profileVC)
    }
}
