//
//  AuthorPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit


protocol AuthorPresenterProtocol {
    var vc: AuthorVCProtocol? { get set }
}

class AuthorPresenter: AuthorPresenterProtocol {
    var vc: AuthorVCProtocol?
    
    
}
