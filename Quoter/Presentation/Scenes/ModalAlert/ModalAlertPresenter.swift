//
//  ModalAlertPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

protocol InteractorToModalAlertPresenterProtocol {
    var vc: PresenterToModalAlertVCProtocol? { get set }
}

class ModalAlertPresenter: InteractorToModalAlertPresenterProtocol {
    var vc: PresenterToModalAlertVCProtocol?
}
