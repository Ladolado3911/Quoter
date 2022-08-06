//
//  AuthorRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit


protocol AuthorRouterProtocol {
    var vc: AuthorVC? { get set }
    
    //func routeToFilterVC(with currentGenre: Genre)
}

final class AuthorRouter: AuthorRouterProtocol {
    weak var vc: AuthorVC?
    
//    func routeToFilterVC(with currentGenre: Genre) {
//        let filterVC = FilterVC()
//        if let vc = vc {
//            filterVC.modalPresentationStyle = .custom
//            filterVC.modalTransitionStyle = .crossDissolve
//            filterVC.filterToExploreDelegate = vc
//            filterVC.currentGenre = currentGenre
//            vc.present(filterVC, animated: false)
//        }
//    }
}
