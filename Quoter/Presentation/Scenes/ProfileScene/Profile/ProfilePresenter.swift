//
//  ProfilePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

enum AccountDeletionResult {
    case success
    case failure(errorMessage: String)
}

protocol ProfilePresenterProtocol {
    var vc: ProfileVCProtocol? { get set }
    
    func setProfileContent(content: UserProfileContent)
    func deleteAccount(result: AccountDeletionResult)
}

class ProfilePresenter: ProfilePresenterProtocol {
    var vc: ProfileVCProtocol?
    
    func setProfileContent(content: UserProfileContent) {
        vc?.setProfileContent(content: content)
    }
    
    func deleteAccount(result: AccountDeletionResult) {
        switch result {
        case .success:
            vc?.accountDeletedSuccessfully()
        case .failure(let errorMessage):
            vc?.accountDeleteFail(errorMessage: errorMessage)
        }
    }
}
