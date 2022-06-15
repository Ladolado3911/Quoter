//
//  AuthorInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit

protocol AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol? { get set }
}

class AuthorInteractor: AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol?
    
    
}
