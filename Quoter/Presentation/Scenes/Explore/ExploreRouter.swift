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
    func routeToModalAlertVC(quoteVM: QuoteGardenQuoteVM)
    func routeToQuotesOfAuthor(resultTuple: ([QuoteGardenQuoteVM], (UIImage?, ImageType)))
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
    
    func routeToQuotesOfAuthor(resultTuple: ([QuoteGardenQuoteVM], (UIImage?, ImageType))) {
        let destVC = QuotesOfAuthorVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.networkQuotesArr = resultTuple.0
        destVC.state = .network
        destVC.networkAuthorImage = resultTuple.1.0
        destVC.authorName = resultTuple.0.first?.authorName
        vc?.present(destVC, animated: true)
    }
    
    func routeToModalAlertVC(quoteVM: QuoteGardenQuoteVM) {
        let modalAlertVC = ModalAlertVC()
        let quoteVM = quoteVM
        modalAlertVC.modalTransitionStyle = .crossDissolve
        modalAlertVC.modalPresentationStyle = .custom
        modalAlertVC.authorName = quoteVM.authorName
        modalAlertVC.passingClosure = { [weak self] resultTuple in
            self?.routeToQuotesOfAuthor(resultTuple: resultTuple)
        }
        modalAlertVC.quoteVM = quoteVM
        vc?.present(modalAlertVC, animated: false)
    }
}
