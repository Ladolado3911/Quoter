//
//  MenuItem.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

final class MenuAuthorizationControllers {
    static var signInVC: UIViewController = {
        let vc = SigninVC()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
    
    static var signInVCModal: UIViewController = {
        let vc = SigninVC()
        vc.signinVCType = .explore
        return vc
    }()
   
    static var profileVC: UIViewController = {
        let vc = ProfileVC()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
    
    static var signUpVC: UIViewController = {
        let vc = SignupVC()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
}
//
//protocol MenuItemProtocol {
//    var title: String { get set }
//    var icon: UIImage { get set }
//    var isSelected: Bool { get set }
//}
//
//protocol MenuSingleItemProtocol {
//    var viewController: UIViewController { get set }
//}
//
//protocol MenuMultipleItemProtocol {
//    var chosen
//}

struct MenuItem {
    let title: String
    let icon: UIImage
    var viewController: UIViewController
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected = true
    }
    
    mutating func deselect() {
        isSelected = false
    }
    
    mutating func switchVC(with vc: UIViewController) {
        
        viewController = vc
    }
}
