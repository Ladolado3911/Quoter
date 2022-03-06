//
//  QoaPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol? { get set }
}

class QoaPresenter: InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol?
}
