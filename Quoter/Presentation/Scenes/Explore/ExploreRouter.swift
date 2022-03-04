//
//  ExploreRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol ExploreRouterProtocol {
    var vc: ExploreVC? { get set }
    
    func routeToFilters()
}

class ExploreRouter: ExploreRouterProtocol {
    weak var vc: ExploreVC?
    
    func routeToFilters() {
        let filterVC = FilterVC()
        filterVC.modalTransitionStyle = .crossDissolve
        filterVC.modalPresentationStyle = .custom
        filterVC.selectedTagStrings = vc?.selectedFilters ?? [""]
        filterVC.dismissClosure = { [weak self] selectedFilters in
            guard let self = self else { return }
            self.vc?.selectedFilters = selectedFilters
            self.vc?.resetInitialData()
            self.vc?.dismiss(animated: true)
        }
        vc?.present(filterVC, animated: true)
    }
}
