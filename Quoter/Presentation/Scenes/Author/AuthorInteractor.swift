//
//  AuthorInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit

protocol AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol? { get set }
    
    func showView()
    func hideView(targetView: AuthorView)
}

class AuthorInteractor: AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol?
    
    func showView() {
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.presenter?.showView()
        }
    }
    
    func hideView(targetView: AuthorView) {
        UIView.animate(withDuration: 1, delay: 0) {
            targetView.frame = CGRect(x: Constants.screenWidth / 2,
                                      y: Constants.screenHeight / 2,
                                      width: 0,
                                      height: 0)
        }
    }
}
