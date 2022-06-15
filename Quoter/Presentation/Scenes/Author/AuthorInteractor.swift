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
    func hideView()
}

class AuthorInteractor: AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol?
    
    func showView() {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.presenter?.showView()
        }
    }
    
    func hideView() {
//        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
//            guard let self = self else { return }
//            self.presenter?.hideView()
//        } completion: { [weak self] didFinish in
//            guard let self = self else { return }
//            if didFinish {
//                self.presenter?.hideView()
//            }
//        }
        
        UIView.animateKeyframes(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.presenter?.hideContent()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.presenter?.hideView()
            }
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.presenter?.dismissView()
            }
        }
        
    }
}
