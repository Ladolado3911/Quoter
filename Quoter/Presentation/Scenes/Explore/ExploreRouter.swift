//
//  ExploreRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExploreRouterProtocol {
    var vc: ExploreVC? { get set }
    
    func routeToFilterVC(with currentGenre: Genre)
    func routeToAuthorVC()
}

class ExploreRouter: ExploreRouterProtocol {
    weak var vc: ExploreVC?
    
    func routeToFilterVC(with currentGenre: Genre) {
        let filterVC = FilterVC()
        if let vc = vc {
            filterVC.modalPresentationStyle = .custom
            filterVC.modalTransitionStyle = .crossDissolve
            filterVC.filterToExploreDelegate = vc
            filterVC.currentGenre = currentGenre
            vc.present(filterVC, animated: false)
        }
    }
    
    func routeToAuthorVC() {
        let authorVC = AuthorVC()
        if let vc = vc {
            authorVC.modalPresentationStyle = .custom
            authorVC.modalTransitionStyle = .crossDissolve
            vc.present(authorVC, animated: false)
        }
    }
}
