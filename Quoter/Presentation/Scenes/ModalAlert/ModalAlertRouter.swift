//
//  ModalAlertRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

protocol ModalAlertRouterProtocol {
    var vc: PresenterToModalAlertVCProtocol? { get set }
}

class ModalAlertRouter: ModalAlertRouterProtocol {
    
    var vc: PresenterToModalAlertVCProtocol?
    
}
