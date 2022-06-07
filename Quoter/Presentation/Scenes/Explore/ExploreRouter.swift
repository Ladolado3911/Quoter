//
//  ExploreRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExploreRouterProtocol {
    var vc: ExploreVC? { get set }
    
    func routeToFilterVC()
}

class ExploreRouter: ExploreRouterProtocol {
    weak var vc: ExploreVC?
    
    func routeToFilterVC() {
        let filterVC = FilterVC()
        let delegate = FilterVCTransitionDelegate()
        if let vc = vc {
            filterVC.modalPresentationStyle = .custom
            filterVC.transitioningDelegate = delegate
            //filterVC.transitioningDelegate = vc
//            filterVC.modalPresentationStyle = .custom
//            filterVC.modalTransitionStyle = .crossDissolve
            vc.present(filterVC, animated: false)
        }
    }
}
