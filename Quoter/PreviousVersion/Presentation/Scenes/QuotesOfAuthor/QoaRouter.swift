//
//  QoaRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol QoaRouterProtocol {
    var vc: PresenterToQoaVCProtocol? { get set }
}

class QoaRouter: QoaRouterProtocol {
    var vc: PresenterToQoaVCProtocol?
}
