//
//  ExploreRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExploreRouterProtocol: AnyObject {
    var vc: ExploreVCProtocol? { get set }
}

class ExploreRouter: ExploreRouterProtocol {
    var vc: ExploreVCProtocol?
}
