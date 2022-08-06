//
//  FilterRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterRouterProtocol {
    var vc: FilterVCProtocol? { get set }
}

final class FilterRouter: FilterRouterProtocol {
    weak var vc: FilterVCProtocol?
}
