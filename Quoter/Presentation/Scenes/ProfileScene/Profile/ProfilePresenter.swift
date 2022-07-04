//
//  ProfilePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfilePresenterProtocol {
    var vc: ProfileVCProtocol? { get set }
    
    func setProfileContent(content: UserProfileContent)
}

class ProfilePresenter: ProfilePresenterProtocol {
    var vc: ProfileVCProtocol?
    
    func setProfileContent(content: UserProfileContent) {
        vc?.setProfileContent(content: content)
    }
}
