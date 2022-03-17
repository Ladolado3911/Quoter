//
//  ExploreRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol ExploreRouterProtocol: AnyObject {
    var vc: PresenterToExploreVCProtocol? { get set }
    
    func routeToFilters(completion: (() -> Void)?)
    func routeToLoadingAlertVC()
    func routeToModalAlertVC(quoteVM: QuoteGardenQuoteVM, completion: (() -> Void)?)
    func routeToQuotesOfAuthor(resultTuple: ([QuoteGardenQuoteVM], (UIImage?, ImageType)), completion: (() -> Void)?)
    func routeToSwipeHint(repeatCount: Float, delay: Int)
}

class ExploreRouter: ExploreRouterProtocol {
    var vc: PresenterToExploreVCProtocol?
    
    func routeToFilters(completion: (() -> Void)?) {
        guard let exploreVC = vc as? ExploreVC else { return }
        let filterVC = FilterVC()
        filterVC.modalTransitionStyle = .crossDissolve
        filterVC.modalPresentationStyle = .custom
        filterVC.interactor!.selectedTagStrings = exploreVC.interactor!.selectedFilters
        filterVC.interactor?.dismissClosure = { selectedFilters in
            exploreVC.interactor!.selectedFilters = selectedFilters
            exploreVC.interactor!.resetInitialData()
            exploreVC.dismiss(animated: true)
        }
        filterVC.interactor?.dismissWithTimerClosure = {
            exploreVC.dismiss(animated: true) {
                if let completion = completion {
                    completion()
                }
            }
        }
        exploreVC.present(filterVC, animated: true)
    }
    
    func routeToQuotesOfAuthor(resultTuple: ([QuoteGardenQuoteVM], (UIImage?, ImageType)), completion: (() -> Void)?) {
        guard let exploreVC = vc as? ExploreVC else { return }
        let destVC = QoaVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.interactor?.dismissWithTimerClosure = completion
        destVC.interactor?.networkQuotesArr = resultTuple.0
        destVC.interactor?.state = .network
        destVC.interactor?.networkAuthorImage = resultTuple.1.0
        destVC.interactor?.authorName = resultTuple.0.first?.authorName
        exploreVC.present(destVC, animated: true)
    }
    
    func routeToModalAlertVC(quoteVM: QuoteGardenQuoteVM, completion: (() -> Void)?) {
        guard let exploreVC = vc as? ExploreVC else { return }
        let modalAlertVC = ModalAlertVC()
        let quoteVM = quoteVM
        modalAlertVC.modalTransitionStyle = .crossDissolve
        modalAlertVC.modalPresentationStyle = .custom
        modalAlertVC.authorName = quoteVM.authorName
        modalAlertVC.passingClosure = { resultTuple in
            self.routeToQuotesOfAuthor(resultTuple: resultTuple, completion: completion)
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
    
    func routeToSwipeHint(repeatCount: Float, delay: Int) {
        guard let exploreVC = vc as? ExploreVC else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay)) {
            let indicatorVC = ScrollIndicatorVC()
            indicatorVC.modalTransitionStyle = .crossDissolve
            indicatorVC.modalPresentationStyle = .custom
            indicatorVC.repeatCount = repeatCount
            indicatorVC.completion = { didFinish in
                if didFinish {
                    indicatorVC.dismiss(animated: true)
                }
            }
            exploreVC.present(indicatorVC, animated: true)
        }
    }
}
