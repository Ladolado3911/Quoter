//
//  ExploreRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol ExploreRouterProtocol: AnyObject {
    var vc: PresenterToExploreVCProtocol? { get set }
    
    func routeToFilters()
    func routeToLoadingAlertVC()
    func routeToModalAlertVC(quoteVM: QuoteGardenQuoteVM)
    func routeToQuotesOfAuthor(resultTuple: ([QuoteGardenQuoteVM], (UIImage?, ImageType)))
}

class ExploreRouter: ExploreRouterProtocol {
    var vc: PresenterToExploreVCProtocol?
    
    func routeToFilters() {
        guard let exploreVC = vc as? ExploreVC else { return }
        let filterVC = FilterVC()
        filterVC.modalTransitionStyle = .crossDissolve
        filterVC.modalPresentationStyle = .custom
        filterVC.selectedTagStrings = exploreVC.interactor!.selectedFilters
        filterVC.dismissClosure = { selectedFilters in
            exploreVC.interactor!.selectedFilters = selectedFilters
            exploreVC.interactor!.resetInitialData()
            exploreVC.dismiss(animated: true)
        }
        exploreVC.present(filterVC, animated: true)
    }
    
    func routeToQuotesOfAuthor(resultTuple: ([QuoteGardenQuoteVM], (UIImage?, ImageType))) {
        guard let exploreVC = vc as? ExploreVC else { return }
        let destVC = QoaVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.interactor?.networkQuotesArr = resultTuple.0
        destVC.interactor?.state = .network
        destVC.interactor?.networkAuthorImage = resultTuple.1.0
        destVC.interactor?.authorName = resultTuple.0.first?.authorName
        exploreVC.present(destVC, animated: true)
    }
    
    func routeToModalAlertVC(quoteVM: QuoteGardenQuoteVM) {
        guard let exploreVC = vc as? ExploreVC else { return }
        let modalAlertVC = ModalAlertVC()
        let quoteVM = quoteVM
        modalAlertVC.modalTransitionStyle = .crossDissolve
        modalAlertVC.modalPresentationStyle = .custom
        modalAlertVC.authorName = quoteVM.authorName
        modalAlertVC.passingClosure = { resultTuple in
            self.routeToQuotesOfAuthor(resultTuple: resultTuple)
        }
        modalAlertVC.quoteVM = quoteVM
        exploreVC.present(modalAlertVC, animated: false)
    }
    
    func routeToLoadingAlertVC() {
        guard let exploreVC = vc as? ExploreVC else { return }
        let loadingAlertVC = LoadingAlertVC()
        loadingAlertVC.modalTransitionStyle = .crossDissolve
        loadingAlertVC.modalPresentationStyle = .custom
        exploreVC.present(loadingAlertVC, animated: false)
    }
}
