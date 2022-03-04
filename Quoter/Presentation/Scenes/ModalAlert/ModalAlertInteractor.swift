//
//  ModalAlertInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

protocol VCToModalAlertInteractorProtocol {
    var presenter: InteractorToModalAlertPresenterProtocol? { get set }
}

class ModalAlertInteractor: VCToModalAlertInteractorProtocol {
    
    var presenter: InteractorToModalAlertPresenterProtocol?
    
    
}
