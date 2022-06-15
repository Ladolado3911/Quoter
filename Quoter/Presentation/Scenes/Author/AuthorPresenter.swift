//
//  AuthorPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit


protocol AuthorPresenterProtocol {
    var vc: AuthorVCProtocol? { get set }
    
    func showView()
    func showContent()
    func hideView()
    func hideContent()
    func dismissView()
}

class AuthorPresenter: AuthorPresenterProtocol {
    var vc: AuthorVCProtocol?
    
    func showView() {
        vc?.showView()
    }
    
    func showContent() {
        vc?.showContent()
    }
    
    func hideView() {
        vc?.hideView()
    }
    
    func hideContent() {
        vc?.hideContent()
    }
    
    func dismissView() {
        vc?.dismissView()
    }
    
}
